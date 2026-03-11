M = 12;
N = 9;
r = 1.5;
close all;


n_out = 1;

test = SphericalScatterer(...
    'sizeParam', r, ...
    'refrIndexOut', n_out, ...
    'refrIndexIn', 2, ...
    'maxHarmNum', M);
test.Calculate();

angles = cell(1, N);
scaMatrices = cell(1, N);
scaMatrices_der = cell(1, N);

for k = 1:N
    scaMatrices{k} = test.scaMatrix;
    scaMatrices_der{k} = test.scaMatrix_der;
    angles{k} = 0;
end
R = 2.5 * r;
coords =  startPosition(N, R);
% coords = {[0; -R/2], [0; R/2;], [R; R/2]};
mTest = MultiSystem(...
    'sizeParam', sqrt(N) * r, ...
    'refrIndexOut', n_out, ...
    'maxHarmNum', M, ...
    'numParticles', N, ...
    'coordinates',coords, ...
    'angles', angles, ...
    'scaMatrices', scaMatrices, ...
    'scaMatrices_der', scaMatrices_der);

% mTest.CalcIterative(100);
mTest.SetIncField('planewave');
mTest.Calculate();
mTest.FarFieldPlot();

return
phiArr = linspace(0, 2*pi, 720);
f = 0 * phiArr;
ind = 1;
q = qMatrix(M, 0, pi/4);
q_ = (q.'*q)\q.';
proj = (eye(2*M+1) - q * q_);
normVal = norm(q * q_) ^ 2;
Esca = mTest.scaCoeffs;

for phi = phiArr
    R = exp(1j * (-M:M).' * phi);
    vec = proj * (R .* Esca);
    f(ind) = vec' * vec / normVal;
    ind = ind + 1;
end


fig = figure;
ax = axes(fig);
maxRho = max(f) * 1.1;
x = f .* cos(phiArr);
y = f .* sin(phiArr);

plot(ax, x, y, 'LineWidth', 1);

xlim(ax, [-maxRho, maxRho]);
ylim(ax, [-maxRho, maxRho]);

ax.Color = 'none';
ax.XColor = 'none';
ax.YColor = 'none';

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
axis equal
hold(ax, 'off');