function obj = CalcIterative(obj, numSteps)

M = obj.maxHarmNum;
N = obj.numParticles;
blockSize = 2*M+1;
mArr = (-M:M);



for k = 1:N
    rotationMat = diag(exp(1j * mArr * obj.angles{k}));
    obj.scaMatrices{k} = rotationMat * obj.scaMatrices{k} * rotationMat';
    x = obj.coordinates{k}(1);
    y = obj.coordinates{k}(2);
    d = sqrt(x^2 + y^2);
    phi = atan2(y, x);
    for m = mArr
        n = mArr;
        mInd = m + M + 1;
        obj.transMatrices{k, k}(mInd, :) = besselj(m-n, d) .* exp(-1j * (m-n) * phi);
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
        for m = mArr
            n = mArr;
            mInd = m + M + 1;
            obj.transMatrices{k1, k2}(mInd, :) = besselh(m-n, d) .* exp(-1j * (m-n) * phi);
            obj.transMatrices{k2, k1}(mInd, :) = obj.transMatrices{k1, k2}(mInd, :) .* exp(-1j * (m-n) * pi);
        end
    end
end

R = diag(exp(-1j * mArr * pi));

eInc_new = cell(1, N);
result = zeros(blockSize);
y3 = zeros(1, numSteps);


% test = SphericalScatterer(...
%     'sizeParam', obj.sizeParam, ...
%     'refrIndexOut', obj.refrIndexOut, ...
%     'refrIndexIn', 2, ...
%     'maxHarmNum', obj.maxHarmNum);
% test.Calculate();
% test2 = SphericalScatterer(...
%     'sizeParam', obj.sizeParam, ...
%     'refrIndexOut', obj.refrIndexOut, ...
%     'refrIndexIn', 2, ...
%     'maxHarmNum', obj.maxHarmNum);
% test2.Calculate();
% d = obj.coordinates{2} - obj.coordinates{1};

for k = 1:N
    eInc_new{k} = obj.transMatrices{k, k};
    retransMatrix = R * obj.transMatrices{k, k} * R.';
    result = result + retransMatrix * obj.scaMatrices{k} * eInc_new{k};
end
% incCoeffs1 =  eInc_new{1} * obj.incCoeffs;
% incCoeffs2 =  eInc_new{2} * obj.incCoeffs;
% alienCoeffs = test.scaMatrix * eInc_new{2} * obj.incCoeffs;
% alienCoeffs2 = test.scaMatrix * eInc_new{1} * obj.incCoeffs;
% test.SetIncField('other', incCoeffs1);
% test.incCoeffs = obj.transMatrices{1, 1} * obj.incCoeffs;
% test2.SetIncField('other', incCoeffs2);
% test2.incCoeffs = obj.transMatrices{2, 2} * obj.incCoeffs;

% y(1) = CheckConditionMulti(test, alienCoeffs, d);
% y2(1) = CheckConditionMulti(test2, alienCoeffs2, -d);

y3(1) = norm(result);
arr = 1:N;
for t = 2:numSteps
    eInc_old = eInc_new;
    for k1 = arr
        eInc_new{k1} = 0 * eInc_new{k1};
        for k2 = arr(arr~=k1)
            eInc_new{k1} = eInc_new{k1} + ...
                obj.transMatrices{k1, k2} * obj.scaMatrices{k2} * eInc_old{k2};
        end
        retransMatrix = R * obj.transMatrices{k1, k1} * R.';
        result = result + retransMatrix * obj.scaMatrices{k1} * eInc_new{k1};
    end
    %     incCoeffs1 = incCoeffs1 + eInc_new{1};
    %     alienCoeffs = test.scaMatrix * eInc_new{2} * obj.incCoeffs;
    %     test.SetIncField('other', incCoeffs1);
    %     test.incCoeffs = obj.transMatrices{1, 1} * obj.incCoeffs;
    
    %     incCoeffs2 = incCoeffs2 + eInc_new{2};
    %     alienCoeffs2 = test.scaMatrix * eInc_new{1} * obj.incCoeffs;
    %     test2.SetIncField('other', incCoeffs2);
    %     test2.incCoeffs = obj.transMatrices{2, 2} * obj.incCoeffs;
    
    %     y(t) = CheckConditionMulti(test, alienCoeffs, d);
    %     y2(t) = CheckConditionMulti(test2, alienCoeffs2, -d);
    y3(t) = norm(result);
    if abs(y3(t) - y3(t-1)) < 1e-3
        break;
    end
end

% figure;
% plot(1:numSteps, log(y), 'DisplayName', '1')
% hold on
% plot(1:numSteps, log(y2), 'DisplayName', '2')
% legend()
% ylabel('Boundary condition')
% yyaxis right
% plot(1:numSteps, y2)
% ylabel('Norm of matrix')

obj.scaMatrix = result;
obj.scaCoeffs = obj.scaMatrix * obj.incCoeffs;


    function err = CheckConditionMulti(particle, alienCoeffs, d)
        % only for shpere yet
        mArr = (-particle.maxHarmNum:particle.maxHarmNum);
        
        condPoints = 32;
        fieldOnBorder = zeros([1, condPoints]);
        phiArr = linspace(0, 2 * pi, condPoints);
        r = particle.sizeParam;
        n1 = particle.refrIndexOut;
        n2 = particle.refrIndexIn;
        
        [X, Y] = pol2cart(phiArr, r * ones(size(phiArr)));
        X2 = X - d(1);
        Y2 = Y - d(2);
        [phiArr2, r2] = cart2pol(X2, Y2);
        
        for m = mArr
            exponent = exp(1j * m * phiArr);
            exponent2 = exp(1j * m * phiArr2);
            mInd = m + particle.maxHarmNum + 1;
            fieldOnBorder = fieldOnBorder + particle.incCoeffs(mInd) .* exponent .* besselj(m, n1 * r);
            fieldOnBorder = fieldOnBorder + particle.scaCoeffs(mInd) .* exponent .* besselh(m, n1 * r);
            fieldOnBorder = fieldOnBorder + alienCoeffs(mInd) .* exponent2 .* besselh(m, n1 * r2);
            fieldOnBorder = fieldOnBorder - particle.intCoeffs(mInd) .* exponent .* besselj(m, n2 * r);
            
            % fieldOnBorder = fieldOnBorder + particle.incCoeffs(mInd) .* exponent .* ...
            %     0.5 .* n1 .* (besselj(m - 1, n1 * r) - besselj(m + 1, n1 * r));
            
            % fieldOnBorder = fieldOnBorder + particle.scaCoeffs(mInd) .* exponent .* ...
            %     0.5 .* n1 .* (besselh(m - 1, n1 * r) - besselh(m + 1, n1 * r));
            
            % fieldOnBorder = fieldOnBorder + alienCoeffs(mInd) .* exponent2 .* ...
            %     0.5 .* n1 .* (besselh(m - 1, n1 * r2) - besselh(m + 1, n1 * r2));
            
            % fieldOnBorder = fieldOnBorder - particle.intCoeffs(mInd) .* exponent .* ...
            %     0.5 .* n2 .* (besselj(m - 1, n2 * r) - besselj(m + 1, n2 * r));
        end
        
        err = sum(abs(fieldOnBorder)) / condPoints;
        
    end



end