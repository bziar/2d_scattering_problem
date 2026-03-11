function obj = Calculate(obj)

M = obj.maxHarmNum;
N = obj.numParticles;
blockSize = 2*M+1;
mArr = (-M:M);
calcDer = true;
if calcDer
    B_der = cell(1, N);
    H_der = cell(1, N);
    % J_der = cell(1, N);
    
    for k = 1:N
        B_der{k} = zeros(blockSize, blockSize * N);
        H_der{k} = zeros(blockSize * N, blockSize * N);
    end
end

for k = 1:N
    rotationMat = diag(exp(1j * mArr * obj.angles{k}));
    obj.scaMatrices{k} = rotationMat * obj.scaMatrices{k} * rotationMat';
    [phi, d] = cart2pol(obj.coordinates{k}(1), obj.coordinates{k}(2));
    for m = mArr
        n = mArr;
        mInd = m + M + 1;
        obj.transMatrices{k, k}(mInd, :) = besselj(m-n, d) .* exp(-1j * (m-n) * phi);
    end
end

for k1 = 1:N
    for k2 = (k1+1):N
        [phi, d] = cart2pol(obj.coordinates{k1}(1) - obj.coordinates{k2}(1), ...
            obj.coordinates{k1}(2) - obj.coordinates{k2}(2));
        for m = mArr
            n = mArr;
            mInd = m + M + 1;
            obj.transMatrices{k1, k2}(mInd, :) = besselh(m-n, d) .* exp(-1j * (m-n) * phi);
            obj.transMatrices{k2, k1}(mInd, :) = obj.transMatrices{k1, k2}(mInd, :) .* exp(-1j * (m-n) * pi);
            
        end
    end
end

R = diag(exp(-1j * mArr * pi));

J = zeros(blockSize * N, blockSize);
B = zeros(blockSize, blockSize * N);
H = zeros(blockSize * N, blockSize * N);

for k = 1:N
    startRow = (k-1)*blockSize + 1;
    endRow = k*blockSize;
    J(startRow:endRow, :) = obj.transMatrices{k, k};
    B(:, startRow:endRow) = R * obj.transMatrices{k, k} * R.' * obj.scaMatrices{k};
    if calcDer
        B_der{k}(:, startRow:endRow) = R * obj.transMatrices{k, k} * R.' * obj.scaMatrices_der{k};
    end
end

for k1 = 1:N
    for k2 = 1:N
        startRow1 = (k1-1)*blockSize + 1;
        endRow1 = k1*blockSize;
        startRow2 = (k2-1)*blockSize + 1;
        endRow2 = k2*blockSize;
        if (k1 == k2)
            H(startRow1:endRow1, startRow2:endRow2) = eye(blockSize);
        else
            H(startRow1:endRow1, startRow2:endRow2) = -obj.transMatrices{k1, k2} * obj.scaMatrices{k2};
            if calcDer
                H_der{k2}(startRow1:endRow1, startRow2:endRow2) = -obj.transMatrices{k1, k2} * obj.scaMatrices_der{k2};
            end
        end
    end
end

% result = B * pinv(H, 1e-6) * J;
% result = B * (H \ J);
% obj.scaMatrix = result;
% obj.scaCoeffs = result * obj.incCoeffs;

% cond_number = cond(B);
% disp(cond_number)
% cond_number = cond(J);
% disp(cond_number)

cond_number = cond(H);
% disp(cond_number)

b = J * obj.incCoeffs;

[x, flag, relres, iter, resvec] = bicgstab(H, b, 1e-5, 1000);
% figure, plot(resvec)

% [x, flag] = lsqr(H, b, 1e-6, 1000);
obj.scaCoeffs = B * x;

if calcDer
    for p = 1:N
        [c, flag, relres, iter, resvec] = bicgstab(H, H_der{p} * b, 1e-4, 1000);
        obj.scaMatrix_der{p} = B_der{p} * b - B * c;
    end
end


end