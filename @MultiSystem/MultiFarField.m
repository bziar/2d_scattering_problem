function ax = MultiFarField(obj, parentAx)

if nargin < 2 || isempty(parentAx)
    fig = figure;
    ax = axes(fig);
else
    ax = parentAx;
end

mArr = (-obj.maxHarmNum:obj.maxHarmNum);
phiPoints = 1200;
indicatrix = zeros([1, phiPoints]);
phiArr = linspace(0, 2 * pi, phiPoints);

for k = 1:obj.numParticles
    alpha = obj.angles{k};
    R = sqrt(obj.coordinates{k}(1)^2 + obj.coordinates{k}(2)^2);
    for m = mArr
        mInd = m + obj.maxHarmNum + 1;
        extraPhase = exp(1j * obj.refrIndexOut * R * cos(alpha + phiArr));
        indicatrix = indicatrix + obj.allCoefs(mInd, k) .* extraPhase .* exp(1j * (m * phiArr - m * pi / 2 - pi / 4));
    end
end

x = abs(indicatrix) .* cos(phiArr);
y = abs(indicatrix) .* sin(phiArr);

plot(ax, x, y, 'LineWidth', 1);
title(ax, ['Far Field, \rho_0 = ', num2str(obj.sizeParam)]);

maxRho = max(abs(indicatrix)) * 1.1;
axis(ax, 'equal');
if maxRho < 1e-12
    warning('Scattered field is zero');
    maxRho = 1e-9;
end
xlim(ax, [-maxRho, maxRho]);
ylim(ax, [-maxRho, maxRho]);

ax.Color = 'none';
ax.XColor = 'none';
ax.YColor = 'none';

if nargin < 2
    hold(ax, 'on');
    theta = linspace(0, 2 * pi, 100);
    plot(ax, maxRho * cos(theta), maxRho * sin(theta), 'k-', 'LineWidth', 0.5);
    
    theta_grid = 0:pi / 4:7 * pi / 4;
    theta_labels = {'0', 'π/4', '', '3π/4', 'π', '5π/4', '', '7π/4'};
    
    for i = 1:length(theta_grid)
        theta = theta_grid(i);
        x_line = [0, maxRho * cos(theta)];
        y_line = [0, maxRho * sin(theta)];
        plot(ax, x_line, y_line, '--', 'Color', [0.8, 0.8, 0.8], 'LineWidth', 0.3);
        
        if ~isempty(theta_labels{i})
            x_text = maxRho * 1.15 * cos(theta);
            y_text = maxRho * 1.15 * sin(theta);
            text(ax, x_text, y_text, theta_labels{i}, 'HorizontalAlignment', 'center', 'FontSize', 8);
        end
        
    end
    
    rho_grid = linspace(maxRho / 4, 3 * maxRho / 4, 3);
    
    for i = 1:length(rho_grid)
        rho = rho_grid(i);
        theta_circle = linspace(0, 2 * pi, 100);
        x_circle = rho * cos(theta_circle);
        y_circle = rho * sin(theta_circle);
        plot(ax, x_circle, y_circle, '--', 'Color', [0.8, 0.8, 0.8], 'LineWidth', 0.3);
        
        text(ax, 0, rho, num2str(rho, '%.2f'), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'FontSize', 8);
    end
    
    hold(ax, 'off');
end
end