function err = CheckCondition(obj, show)

if nargin < 2
    show = false;
end

mArr = (-obj.maxHarmNum:obj.maxHarmNum);

condPoints = 32;
fieldOnBorder = zeros([1, condPoints]);
phiArr = linspace(0, 2 * pi, condPoints);
r = obj.sizeParam;
n1 = obj.refrIndexOut;
n2 = obj.refrIndexIn;

for m = mArr
    exponent = exp(1j * m * phiArr);
    mInd = m + obj.maxHarmNum + 1;
    fieldOnBorder = fieldOnBorder + obj.incCoeffs(mInd) .* exponent .* besselj(m, n1 * r);
    fieldOnBorder = fieldOnBorder + obj.scaCoeffs(mInd) .* exponent .* besselh(m, n1 * r);
    fieldOnBorder = fieldOnBorder - obj.intCoeffs(mInd) .* exponent .* besselj(m, n2 * r);
    
    fieldOnBorder = fieldOnBorder + obj.incCoeffs(mInd) .* exponent .* ...
        0.5 .* n1 .* (besselj(m - 1, n1 * r) - besselj(m + 1, n1 * r));
    
    fieldOnBorder = fieldOnBorder + obj.scaCoeffs(mInd) .* exponent .* ...
        0.5 .* n1 .* (besselh(m - 1, n1 * r) - besselh(m + 1, n1 * r));
    
    fieldOnBorder = fieldOnBorder - obj.intCoeffs(mInd) .* exponent .* ...
        0.5 .* n2 .* (besselj(m - 1, n2 * r) - besselj(m + 1, n2 * r));
end

obj.condViolation = sum(abs(fieldOnBorder)) / condPoints;
err = obj.condViolation;
if show
    disp('Condition is ' + string(obj.condViolation) + ' at ' + string(condPoints) + ' points.')
end

end