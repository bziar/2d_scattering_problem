function CheckCondition(obj, show)

if nargin < 2
    show = true;
end

mArr = (-obj.maxHarmNum:obj.maxHarmNum);

condPoints = 32;
fieldOnBorder = zeros([1, condPoints]);
phiArr = linspace(0, 2 * pi, condPoints+1);
phiArr = phiArr(1:end-1);
[s, sD] = obj.ShapeCalc(phiArr);
r = obj.sizeParam * s;
rD = obj.sizeParam * sD;
n1 = obj.refrIndexOut;
n2 = obj.refrIndexIn;

for m = mArr
    exponent = exp(1j * m * phiArr);
    mInd = m + obj.maxHarmNum + 1;
    fieldOnBorder = fieldOnBorder + obj.incCoeffs(mInd) .* exponent .* besselj(m, n1 * r);
    fieldOnBorder = fieldOnBorder + obj.scaCoeffs(mInd) .* exponent .* besselh(m, n1 * r);
    fieldOnBorder = fieldOnBorder - obj.intCoeffs(mInd) .* exponent .* besselj(m, n2 * r);
    
    fieldOnBorder = fieldOnBorder + obj.incCoeffs(mInd) .* exponent .* ...
        n1 .* (r .* 0.5 .* (besselj(m-1, n1 .* r) - besselj(m+1, n1 .* r)) - ...
        1j * m * rD ./ r .* besselj(m, n1 .* r)) ./ sqrt(r.^2 + rD.^2);
    
    fieldOnBorder = fieldOnBorder + obj.scaCoeffs(mInd) .* exponent .* ...
        n1 .* (r .* 0.5 .* (besselh(m-1, n1 .* r) - besselh(m+1, n1 .* r)) - ...
        1j * m * rD ./ r .* besselh(m, n1 .* r)) ./ sqrt(r.^2 + rD.^2);
    
    fieldOnBorder = fieldOnBorder - obj.intCoeffs(mInd) .* exponent .* ...
        n2 .* (r .* 0.5 .* (besselj(m-1, n2 .* r) - besselj(m+1, n2 .* r)) - ...
        1j * m * rD ./ r .* besselj(m, n2 .* r)) ./ sqrt(r.^2 + rD.^2);
end

obj.condViolation = sum(abs(fieldOnBorder)) / condPoints;

if show
    disp('Condition is ' + string(obj.condViolation) + ' at ' + string(condPoints) + ' points.')
end

end