function sigma = CrossSection(obj, direction, width)

if nargin < 3
    direction = 0;
    width = 2*pi;
else
    direction = mod(direction, 2*pi);
    width = mod(width, 2*pi);
end

mArr = (-obj.maxHarmNum:obj.maxHarmNum);
phiPoints = 720;
indicatrix = zeros([1, phiPoints]);
incField = zeros([1, phiPoints]);
phiArr = linspace(0, 2*pi, phiPoints+1);
phiArr = phiArr(1:end-1);

for m = mArr
    mInd = m + obj.maxHarmNum + 1;
    indicatrix = indicatrix + obj.scaCoeffs(mInd) * exp(1j * (m * phiArr - m * pi / 2 - pi / 4));
    incField = incField + obj.incCoeffs(mInd) * exp(1j * (m * phiArr - m * pi / 2 - pi / 4));
end

diff = abs(phiArr - direction);
region = min(diff, 2*pi - diff) <= width;

sigma = sum(abs(indicatrix(region)).^2) / sum(abs(incField).^2);
end