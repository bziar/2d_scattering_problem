function obj = CalcIterative(obj, numSteps, calcDer)
if nargin < 3
    calcDer = false;
end
calcDer = false;

M = obj.maxHarmNum;
N = obj.numParticles;
blockSize = 2*M+1;
mArr = (-M:M);

if calcDer
    transMatrices_der_x = cell(N, N);
    transMatrices_der_y = cell(N, N);
end

for k = 1:N
    rotationMat = diag(exp(1j * mArr * obj.angles{k}));
    obj.scaMatrices{k} = rotationMat * obj.scaMatrices{k} * rotationMat';
    
    x = obj.coordinates{k}(1);
    y = obj.coordinates{k}(2);
    d = sqrt(x^2 + y^2);
    phi = atan2(y, x);
    
    d_x = x / d;
    d_y = y / d;
    phi_x = -y / d / d;
    phi_y = x / d / d;
    
    for m = mArr
        n = mArr;
        mInd = m + M + 1;
        obj.transMatrices{k, k}(mInd, :) = besselj(m-n, d) .* exp(-1j * (m-n) * phi);
        
        if calcDer
            transMatrices_der_x{k, k}(mInd, :) = (0.5 * (besselj(m-n-1, d) - besselj(m-n+1, d)) * d_x - ...
                1j * (m-n) .* besselj(m-n, d) * phi_x) .* exp(-1j * (m-n) * phi);
            transMatrices_der_y{k, k}(mInd, :) = (0.5 * (besselj(m-n-1, d) - besselj(m-n+1, d)) * d_y - ...
                1j * (m-n) .* besselj(m-n, d) * phi_y) .* exp(-1j * (m-n) * phi);
        end
    end
end

for k1 = 1:N
    for k2 = (k1+1):N
        x1 = obj.coordinates{k1}(1);
        y1 = obj.coordinates{k1}(2);
        x2 = obj.coordinates{k2}(1);
        y2 = obj.coordinates{k2}(2);
        
        d = sqrt((x1 - x2)^2 + (y1 - y2)^2);
        phi = atan2((y1 - y2), (x1 - x2));
        
        d_x = (x1 - x2) / d;
        d_y = (y1 - y2) / d;
        phi_x = -(y1 - y2) / d / d;
        phi_y = (x1 - x2) / d / d;
        
        for m = mArr
            n = mArr;
            mInd = m + M + 1;
            obj.transMatrices{k1, k2}(mInd, :) = besselh(m-n, d) .* exp(-1j * (m-n) * phi);
            obj.transMatrices{k2, k1}(mInd, :) = obj.transMatrices{k1, k2}(mInd, :) .* exp(-1j * (m-n) * pi);
            
            if calcDer
                transMatrices_der_x{k1, k2}(mInd, :) = (0.5 * (besselj(m-n-1, d) - besselj(m-n+1, d)) * d_x - ...
                    1j * (m-n) .* besselj(m-n, d) * phi_x) .* exp(-1j * (m-n) * phi);
                transMatrices_der_x{k2, k1}(mInd, :) = transMatrices_der_x{k1, k2}(mInd, :) .* exp(-1j * (m-n) * pi);
                transMatrices_der_y{k1, k2}(mInd, :) = (0.5 * (besselj(m-n-1, d) - besselj(m-n+1, d)) * d_y - ...
                    1j * (m-n) .* besselj(m-n, d) * phi_y) .* exp(-1j * (m-n) * phi);
                transMatrices_der_y{k2, k1}(mInd, :) = transMatrices_der_y{k1, k2}(mInd, :) .* exp(-1j * (m-n) * pi);
            end
        end
    end
end

R = diag(exp(-1j * mArr * pi));
numP = obj.numP;
eInc_new = cell(1, N);
result = zeros(blockSize);

if calcDer
    eInc_new_der = cell(numP, N);
    result_der = cell(1, numP);
    for p = 1:numP
        for k = 1:N
            eInc_new_der{p, k} = zeros(blockSize);
        end
        result_der{p} = zeros(blockSize);
    end
end

y3 = zeros(1, numSteps);

for k = 1:N
    eInc_new{k} = obj.transMatrices{k, k};
    retransMatrix = R * obj.transMatrices{k, k} * R.';
    result = result + retransMatrix * obj.scaMatrices{k} * eInc_new{k};
    
    if calcDer
        % Derivative by x-shift
        eInc_new_der{N+2*k-1, k} = transMatrices_der_x{k, k};
        % Derivative by y-shift
        eInc_new_der{N+2*k, k} = transMatrices_der_y{k, k};
        
        % Derivative by radius
        result_der{k} = result_der{k} + retransMatrix * obj.scaMatrices_der{k} * eInc_new{k};
        % Derivative by x-shift
        retransMatrix_der = R * transMatrices_der_x{k, k} * R.';
        result_der{N+2*k-1} = result_der{N+2*k-1} + retransMatrix_der * obj.scaMatrices{k} * eInc_new{k} + ...
            retransMatrix * obj.scaMatrices{k} * eInc_new_der{N+2*k-1, k};
        % Derivative by y-shift
        retransMatrix_der = R * transMatrices_der_y{k, k} * R.';
        result_der{N+2*k} = result_der{N+2*k} + retransMatrix_der * obj.scaMatrices{k} * eInc_new{k} + ...
            retransMatrix * obj.scaMatrices{k} * eInc_new_der{N+2*k, k};
    end
end

y3(1) = norm(result);
arr = 1:N;
counter = 1;
for t = 2:numSteps
    eInc_old = eInc_new;
    if calcDer
        eInc_old_der = eInc_new_der;
    end
    for k1 = arr
        eInc_new{k1} = 0 * eInc_new{k1};
        if calcDer
            for p = 1:numP
                eInc_new_der{p, k1} = 0 * eInc_new_der{p, k1};
            end
        end
        for k2 = arr(arr~=k1)
            eInc_new{k1} = eInc_new{k1} + ...
                obj.transMatrices{k1, k2} * obj.scaMatrices{k2} * eInc_old{k2};
            if calcDer
                % Derivative by radius 2
                eInc_new_der{k2, k1} = eInc_new_der{k2, k1} + ...
                    obj.transMatrices{k1, k2} * obj.scaMatrices_der{k2} * eInc_old{k2} + ...
                    obj.transMatrices{k1, k2} * obj.scaMatrices{k2} * eInc_old_der{k2, k2};
                % Derivative by x1-shift
                eInc_new_der{N+2*k1-1, k1} = eInc_new_der{N+2*k1-1, k1} + ...
                    transMatrices_der_x{k1, k2} * obj.scaMatrices{k2} * eInc_old{k2} + ...
                    obj.transMatrices{k1, k2} * obj.scaMatrices{k2} * eInc_old_der{N+2*k1-1, k2};
                % Derivative by y1-shift
                eInc_new_der{N+2*k1, k1} = eInc_new_der{N+2*k1, k1} + ...
                    transMatrices_der_y{k1, k2} * obj.scaMatrices{k2} * eInc_old{k2} + ...
                    obj.transMatrices{k1, k2} * obj.scaMatrices{k2} * eInc_old_der{N+2*k1, k2};
                % Derivative by x2-shift
                eInc_new_der{N+2*k2-1, k1} = eInc_new_der{N+2*k2-1, k1} - ...
                    transMatrices_der_x{k1, k2} * obj.scaMatrices{k2} * eInc_old{k2} + ...
                    obj.transMatrices{k1, k2} * obj.scaMatrices{k2} * eInc_old_der{N+2*k2-1, k2};
                % Derivative by y2-shift
                eInc_new_der{N+2*k2, k1} = eInc_new_der{N+2*k2, k1} - ...
                    transMatrices_der_y{k1, k2} * obj.scaMatrices{k2} * eInc_old{k2} + ...
                    obj.transMatrices{k1, k2} * obj.scaMatrices{k2} * eInc_old_der{N+2*k2, k2};
            end
        end
        retransMatrix = R * obj.transMatrices{k1, k1} * R.';
        result = result + retransMatrix * obj.scaMatrices{k1} * eInc_new{k1};
        if calcDer
            % Derivative by radius
            result_der{k1} = result_der{k1} + retransMatrix * obj.scaMatrices_der{k1} * eInc_new{k1} + ...
                retransMatrix * obj.scaMatrices{k1} * eInc_new_der{k1, k1};
            % Derivative by x1-shift
            retransMatrix_der = R * transMatrices_der_x{k1, k1} * R.';
            result_der{N+2*k1-1} = retransMatrix_der * obj.scaMatrices{k1} * eInc_new{k1} + ...
                retransMatrix * obj.scaMatrices{k1} * eInc_new_der{N+2*k1-1, k1};
            % Derivative by y1-shift
            retransMatrix_der = R * transMatrices_der_y{k1, k1} * R.';
            result_der{N+2*k1} = retransMatrix_der * obj.scaMatrices{k1} * eInc_new{k1} + ...
                retransMatrix * obj.scaMatrices{k1} * eInc_new_der{N+2*k1, k1};
        end
    end
    
    
    
    
    y3(t) = norm(result);
    if abs(y3(t) - y3(t-1)) < 1e-3
        counter = counter+1;
        if counter > 5
            break;
        end
    else
        counter = 1;
    end
    
    if (y3(t)) > 1e2
        warning('BLOW UP!');
        break
    end
end
figure;
plot(y3)
obj.scaMatrix = result;
if calcDer
    obj.scaMatrix_der = result_der;
end
obj.scaCoeffs = obj.scaMatrix * obj.incCoeffs;



end