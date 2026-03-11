function ax = NearFieldPlot(obj, varargin)
resolution = 128;
scale = 2;
parentAx = [];

for i = 1:2:length(varargin)
    
    if i + 1 <= length(varargin)
        
        switch lower(varargin{i})
            case 'resolution'
                resolution = varargin{i + 1};
            case 'scale'
                scale = varargin{i + 1};
            case 'parent'
                parentAx = varargin{i + 1};
        end
        
    end
    
end

if isempty(parentAx)
    ax = gca;
else
    ax = parentAx;
end

xMax = obj.sizeParam * scale;
yMax = obj.sizeParam * scale;

xArr = linspace(-xMax, xMax, resolution);
yArr = linspace(-yMax, yMax, resolution);

[xGrid, yGrid] = meshgrid(xArr, yArr);
[phiGrid, rGrid] = cart2pol(xGrid, yGrid);

incField = zeros(size(rGrid));
scaField = zeros(size(rGrid));
intField = zeros(size(rGrid));

outer = rGrid > obj.sizeParam;
inner = rGrid <= obj.sizeParam;

mArr = (-obj.maxHarmNum:obj.maxHarmNum);
fprintf('Plot progress: \n');

for m = mArr
    mInd = m + obj.maxHarmNum + 1;
    fprintf('%d/%d\n', mInd, 2 * obj.maxHarmNum + 1);
    exponent = exp(1j * m * phiGrid);
    incField(outer) = incField(outer) + obj.incCoeffs(mInd) * exponent(outer) .* besselj(m, obj.refrIndexOut * rGrid(outer));
    scaField(outer) = scaField(outer) + obj.scaCoeffs(mInd) * exponent(outer) .* besselh(m, obj.refrIndexOut * rGrid(outer));
    intField(inner) = intField(inner) + obj.intCoeffs(mInd) * exponent(inner) .* besselj(m, obj.refrIndexIn * rGrid(inner));
end

fprintf('\n');

totalField = incField + scaField + intField;
obj.CheckCondition();
pcolor(ax, xGrid, yGrid, abs(totalField));
shading(ax, 'flat');
xlabel(ax, 'x');
ylabel(ax, 'y');
title(ax, ['|E|^2, maxHarm = ', num2str(obj.maxHarmNum), ', Cond = ', num2str(obj.condViolation)]);
colorbar(ax);
colormap(ax, 'jet');

phiPoints = 360;
phiArr = linspace(0, 2 * pi, phiPoints);
hold(ax, 'on');
plot(ax, obj.sizeParam .* cos(phiArr), obj.sizeParam .* sin(phiArr), '--', 'Color', 'Black', 'LineWidth', 1);
daspect(ax, [1 1 1]);
end