function obj = Calculate4(obj, calcDer)
% Calculate3
% Оптимизированная реализация расчёта (прямая + adjoint), ориентированная на
% ускорение расчёта производных:
%   * не строит глобальные матрицы производных размера (N(2M+1))^2 для каждого параметра;
%   * использует блочные формулы adjoint (только те блоки, которые реально зависят от параметра);
%   * переводные матрицы T_{i,j} строятся как Toeplitz по разности (m-n), что снижает
%     число вызовов bessel* с O((2M+1)^2) до O(4M+1) на пару частиц.

M = obj.maxHarmNum;
M1 = obj.maxHarmNum1;
N = obj.numParticles;
blockSize = 2*M + 1;
totalSize = blockSize * N;

blockSize1 = 2*M1 + 1;
totalSize1 = blockSize1 * N;

mArr = (-M:M).';
diffVec = (-2*M:2*M).';
mid = 2*M + 1; % diff=0

mArr1 = (-M1:M1).';
diffVec1 = (-2*M1:2*M1).';
mid1 = 2*M1 + 1; % diff=0

if nargin < 2
    calcDer = true;
end

%% Предвычисления
R = diag(exp(-1j * mArr * pi));

epiVec = exp(-1j * diffVec * pi);
Epi = toeplitz(epiVec(mid:end), epiVec(mid:-1:1));

epiVec1 = exp(-1j * diffVec1 * pi);
Epi1 = toeplitz(epiVec1(mid1:end), epiVec1(mid1:-1:1));

rotationMatrices = cell(1, N);
for k = 1:N
    rotationMatrices{k} = diag(exp(1j * mArr1 * obj.angles{k}));
end

% Локальные копии, чтобы избежать накопления поворотов
scaM = obj.scaMatrices;
scaM_der = obj.scaMatrices_der;
for k = 1:N
    for s = 1:4
        Rk = rotationMatrices{k};
        scaM{k} = Rk * scaM{k} * Rk';
        if calcDer && ~isempty(scaM_der)
            scaM_der{4*(k-1)+s} = Rk * scaM_der{4*(k-1)+s} * Rk';
        end
    end
end

%% Переводные матрицы
transMatrices = cell(N, N);
[transMatrices{:,:}] = deal(zeros(blockSize, blockSize));

for k = 1:N
    x = obj.coordinates{k}(1);
    y = obj.coordinates{k}(2);
    [phi, d0] = cart2pol(x, y);
    d = obj.refrIndexOut * d0;
    transMatrices{k, k} = buildToeplitzTrans(diffVec, mid, d, phi, 'j');
    % transMatrices{k, k} = diag(exp(1j * obj.refrIndexOut * x));
end

for k1 = 1:N
    x1 = obj.coordinates{k1}(1);
    y1 = obj.coordinates{k1}(2);
    for k2 = (k1+1):N
        x2 = obj.coordinates{k2}(1);
        y2 = obj.coordinates{k2}(2);
        
        dx = x1 - x2;
        dy = y1 - y2;
        phi = atan2(dy, dx);
        d = obj.refrIndexOut * hypot(dx, dy);
        
        T12 = buildToeplitzTrans(diffVec1, mid1, d, phi, 'h');
        transMatrices{k1, k2} = T12;
        transMatrices{k2, k1} = T12 .* Epi1;
    end
end

%% Глобальная матрица H
if totalSize1 <= 5000
    H = zeros(totalSize1);
else
    H = speye(totalSize1);
end

% Сначала диагональные блоки
for k = 1:N
    idx = (k-1)*blockSize1 + (1:blockSize1);
    H(idx, idx) = eye(blockSize1);
end

% Затем недиагональные блоки
for j = 1:N
    cols = (j-1)*blockSize1 + (1:blockSize1);
    Sj = scaM{j};
    for i = 1:N
        if i == j
            continue;
        end
        rows = (i-1)*blockSize1 + (1:blockSize1);
        H(rows, cols) = -transMatrices{i, j} * Sj;
    end
end


%% RHS: b = J * incCoeffs (J не строим)
b = zeros(totalSize1, 1);
for k = 1:N
    idx = (k-1)*blockSize1 + (1:blockSize1);
    matr = transMatrices{k, k};
    b(idx) = matr(M-M1+1:M-M1+1+2*M1, :) * obj.incCoeffs;
end

%% Решение прямой задачи
if totalSize1 < 1000
    right = H \ b;
else
    [right, flag] = bicgstab(H, b, 1e-3, min(5000, totalSize1*2));
    if flag ~= 0
        [right, flag2] = lsqr(H, b, 1e-6, 2000);
        if flag2 ~= 0
            right = H \ b;
        end
    end
end

Right = reshape(right, blockSize1, N);

%% Выходные коэффициенты a = B * right (B не строим)
Tkkr = cell(1, N);           % R*Tkk*R.'
Sx = zeros(blockSize1, N);    % S_k * x_k
for k = 1:N
    Tkkr{k} = R * transMatrices{k, k} * R.';
    % Tkkr{k} = eye(blockSize);
    Sx(:, k) = scaM{k} * Right(:, k);
end
obj.allCoefs = Sx;

a = zeros(blockSize, 1);
for k = 1:N
    matr = Tkkr{k};
    a = a + matr(:, M-M1+1:M-M1+1+2*M1) * Sx(:, k);
end
obj.scaCoeffs = a;

nrm = (a' * a);
q = ((a' * obj.Q * a) / nrm);
obj.targetFunc = q;

%% Adjoint и производные
if calcDer
    dqdEs = ((a' * obj.Q - q * a') / nrm);   % 1 x blockSize
    dqdEs_col = dqdEs.';
    
    % b2 = B.' * dqdEs.' (B не строим)
    b2 = zeros(totalSize1, 1);
    for k = 1:N
        idx = (k-1)*blockSize1 + (1:blockSize1);
        matr = Tkkr{k};
        Bk = matr(:, M-M1+1:M-M1+1+2*M1) * scaM{k};
        b2(idx) = Bk.' * dqdEs_col;
    end
    
    % Решаем H.' * lambda = b2
    if totalSize1 < 1000
        lmbd = H.' \ b2;
    else
        [lmbd, flag] = bicgstab(H.', b2, 1e-3, min(5000, totalSize1*2));
        if flag ~= 0
            [lmbd, flag2] = lsqr(H.', b2, 1e-6, 2000);
            if flag2 ~= 0
                lmbd = H.' \ b2;
            end
        end
    end
    
    Lambda = reshape(lmbd, blockSize1, N);
    
    %% Производные по параметрам формы (индексы 1..N)
    for k = 1:N
        for s = 1:4
            w = scaM_der{4*(k-1)+s} * Right(:, k);
            matr = Tkkr{k};
            termB = dqdEs * (matr(:, M-M1+1:M-M1+1+2*M1) * w);
            
            termH = 0;
            for i = 1:N
                if i == k
                    continue;
                end
                termH = termH + (Lambda(:, i).' * (transMatrices{i, k} * w));
            end
            
            obj.scaMatrix_der{4*(k-1)+s} = termB + termH;
        end
    end
    
end
end


%% ===== Helpers =====
function T = buildToeplitzTrans(diffVec, mid, d, phi, kind)
phase = exp(-1j * diffVec * phi);
switch kind
    case 'j'
        v = besselj(diffVec, d) .* phase;
    case 'h'
        v = besselh(diffVec, d) .* phase;
    otherwise
        error('Unknown kind: %s', kind);
end

% ВАЖНО: конвенция как в v1: diff = (col - row)
c = v(mid:-1:1);   % diff = 0, -1, -2, ...
r = v(mid:end);    % diff = 0, +1, +2, ...
T = toeplitz(c, r);
end

function dT = buildToeplitzDer(diffVec, mid, d, phi, k0, d_xy, phi_xy, kind)
ordersExt = (diffVec(1)-1 : diffVec(end)+1).';
switch kind
    case 'j'
        ext = besselj(ordersExt, d);
    case 'h'
        ext = besselh(ordersExt, d);
    otherwise
        error('Unknown kind: %s', kind);
end
F   = ext(2:end-1);
Fm1 = ext(1:end-2);
Fp1 = ext(3:end);

phase = exp(-1j * diffVec * phi);
v = (0.5 * k0 * (Fm1 - Fp1) * d_xy - 1j * diffVec .* F * phi_xy) .* phase;

% Та же конвенция (col - row)
c = v(mid:-1:1);
r = v(mid:end);
dT = toeplitz(c, r);
end
