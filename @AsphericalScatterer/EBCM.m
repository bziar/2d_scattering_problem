function EBCM(obj)

% =======================
% Параметры (локальные)
% =======================
M  = obj.maxHarmNum;
N  = obj.shapeGridSize;
n1 = obj.refrIndexOut;
n2 = obj.refrIndexIn;
r0 = obj.sizeParam;

f  = obj.shape;      % вектор
fD = obj.shDer;      % вектор

P = 1;

% =======================
% Сетка по phi
% =======================
phiArr = linspace(0, 2*pi, N+1);
phiArr(end) = [];

% =======================
% Индексы m
% =======================
M_expand = M + P + 1;
m_arr = -M_expand : M_expand+1;
Nm = numel(m_arr);

centerShift = M_expand + 1;
mainIdx = (P+2):(2*M + P + 3);

% =======================
% Предвыделение
% =======================
Q1 = zeros(2*M+1);
Q2 = zeros(2*M+1);

alpha1 = zeros(P+1, 2*M+2, N);
alpha2 = zeros(P+1, 2*M+2, N);
beta   = zeros(P+1, 2*M+2, N);

eta1  = zeros(P, 2*M+1, N);
eta2  = zeros(P, 2*M+1, N);
sigma = zeros(P, 2*M+1, N);

% =======================
% Bessel аргументы
% =======================
arg1 = n1*r0*f;
arg2 = n2*r0*f;

% =======================
% Начальные Bessel
% =======================
tmp1 = zeros(2, Nm, N);
tmp2 = zeros(2, Nm, N);
tmpB = zeros(2, Nm, N);

for k = 1:Nm
    mval = m_arr(k);
    tmp1(1,k,:) = besselj(mval, arg1);
    tmp2(1,k,:) = besselj(mval, arg2);
    tmpB(1,k,:) = besselh(mval, arg1);
end

alpha1(1,:,:) = tmp1(1, mainIdx, :);
alpha2(1,:,:) = tmp2(1, mainIdx, :);
beta(1,:,:)   = tmpB(1, mainIdx, :);

% =======================
% Производные по рекуррентной формуле
% =======================
for p = 2:(P+1)

    range = p:(Nm-p+1);

    tmp1(2,range,:) = 0.5*(tmp1(1,range-1,:) - tmp1(1,range+1,:));
    tmp2(2,range,:) = 0.5*(tmp2(1,range-1,:) - tmp2(1,range+1,:));
    tmpB(2,range,:) = 0.5*(tmpB(1,range-1,:) - tmpB(1,range+1,:));

    alpha1(p,:,:) = tmp1(2, mainIdx, :);
    alpha2(p,:,:) = tmp2(2, mainIdx, :);
    beta(p,:,:)   = tmpB(2, mainIdx, :);

    tmp1(1,:,:) = tmp1(2,:,:);
    tmp2(1,:,:) = tmp2(2,:,:);
    tmpB(1,:,:) = tmpB(2,:,:);
end

% =======================
% Предвычисление знаменателей
% =======================
m_vals = -M:M;
den = 1 ./ (m_vals);

valid = [1:M, M+2:2*M+1];

for p = 1:P
    eta1(p,valid,:) = ...
        (alpha1(p+1,valid,:) + alpha1(p,valid+1,:)) .* ...
        reshape(den(valid),1,[],1);

    eta2(p,valid,:) = ...
        (alpha2(p+1,valid,:) + alpha2(p,valid+1,:)) .* ...
        reshape(den(valid),1,[],1);

    sigma(p,valid,:) = ...
        (beta(p+1,valid,:) + beta(p,valid+1,:)) .* ...
        reshape(den(valid),1,[],1);
end

% =======================
% Экспоненты e^{i(m1-m2)phi}
% =======================
deltaM = (-2*M):(2*M);
E = exp(1j * (deltaM.') * phiArr);  % (4M+1) x N

% =======================
% Общие множители
% =======================
c1 = -0.25j * r0;
c2 =  0.25j * r0;

% =======================
% Основной цикл
% =======================
for i2 = 1:(2*M+1)

    m2 = m_vals(i2);

    a0_m2 = squeeze(alpha1(1,i2,:)).';
    a1_m2 = squeeze(alpha1(2,i2,:)).';
    b0_m2 = squeeze(beta(1,i2,:)).';
    b1_m2 = squeeze(beta(2,i2,:)).';
    eta_m2 = squeeze(eta1(1,i2,:)).';
    sig_m2 = squeeze(sigma(1,i2,:)).';

    for i1 = 1:(2*M+1)

        m1 = m_vals(i1);

        A0_m1 = squeeze(alpha2(1,i1,:)).';
        A1_m1 = squeeze(alpha2(2,i1,:)).';
        Eta_m1 = squeeze(eta2(1,i1,:)).';

        expTerm = E(m1-m2 + 2*M + 1, :);

        integrand1 = ( ...
            n1*A0_m1 .* (b1_m2.*f + 1j*m2*sig_m2.*fD) ...
          - n2*b0_m2 .* (A1_m1.*f - 1j*m1*Eta_m1.*fD) ...
          ) .* expTerm;

        integrand2 = ( ...
            n1*A0_m1 .* (a1_m2.*f + 1j*m2*eta_m2.*fD) ...
          - n2*a0_m2 .* (A1_m1.*f - 1j*m1*Eta_m1.*fD) ...
          ) .* expTerm;

        Q1(i2,i1) = c1 * trapz(phiArr, integrand1);
        Q2(i2,i1) = c2 * trapz(phiArr, integrand2);
    end
end

% =======================
% Решение без inv()
% =======================
obj.intMatrix = eye(size(Q1)) / Q1;
obj.scaMatrix = (Q2 / Q1).';

obj.intCoeffs = obj.intMatrix * obj.incCoeffs;
obj.scaCoeffs = obj.scaMatrix * obj.incCoeffs;

end