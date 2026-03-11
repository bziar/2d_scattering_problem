clear all;
close all;

M = 90;
r = 10;
n1 = 1;
n2 = 2;

x = linspace(0, 0.1, 30);
x = x(1:end-1);
y = [];
a = 0;
tic 
for c = 0.02
    
    % test = AsphericalScatterer(...
    %     'sizeParam', r, ...
    %     'refrIndexOut', n1, ...
    %     'refrIndexIn', n2, ...
    %     'maxHarmNum', M, ...
    %     'maxShapeCoeffsNum', 4, ...
    %     'shapeGridSize', 2^11+1);
    % test.SetIncField('planewave');
    % test.ShapeUpdate([zeros(1, 6), c, 0]);
    % % test.ShapeUpdate([0, 0, 0.5, 0, 0, 0, 0, -0.15]);
    % test.EBCM();
    % % test.ShapePlot();
    % % test.FarFieldPlot();

    % S = test.scaMatrix;

    test = SphericalScatterer(...
        'sizeParam', r, ...
        'refrIndexOut', n1, ...
        'refrIndexIn', n2, ...
        'maxHarmNum', M);
    test.Calculate();
    test.SetIncField('planewave');
    % test.FarFieldPlot();
    
    S1 = test.scaMatrix;
    R = 2.5*r;
    N = 9;
    scaMatrices = cell(1, N);
    angles = cell(1, N);
    for k = 1:N
        scaMatrices{k} = S1;
        angles{k} = 0;
    end
    init_coord = startPosition(N, R);
    mTest = MultiSystem(...
        'sizeParam', 1*r, ...
        'refrIndexOut', n1, ...
        'maxHarmNum', M, ...
        'numParticles', 4, ...
        'coordinates', init_coord, ...
        'angles', angles, ...
        'scaMatrices', scaMatrices);

    mTest.SetIncField('planewave');
    mTest.CalcIterative(30);
    mTest.SetIncField('planewave');
    mTest.FarFieldPlot();

    % mTest.SetIncField('other', 1j.^(-M:M).' .* exp(-1j * (-M:M).' * pi/2));
    % mTest.FarFieldPlot();

    % mTest.Calculate();
    % mTest.SetIncField('planewave');
    % mTest.FarFieldPlot();

    y = [y mTest.CrossSection(pi/4, pi/2)];
end
toc
% figure, plot(x, y)








return
M = 60;

q = linspace(17, 20, 8193);
y1 = zeros(numel(q), 3);
ind = 1;
for r = q
    test = SphericalScatterer(...
        'sizeParam', r, ...
        'refrIndexOut', 1.5, ...
        'refrIndexIn', 2.5, ...
        'maxHarmNum', M);
    t11_norm = min(abs(test.border.transferMatrix(1:2*M+1, 1)));
    t21_norm = max(abs(test.border.transferMatrix(1:2*M+1, 2)));
    s_norm = max(abs(test.border.outerReflection));
    y(ind, 1) = t11_norm;
    y(ind, 2) = t21_norm;
    y(ind, 3) = s_norm;
    ind = ind + 1;
    % test.SetIncField('planewave');
    % test.CombinedPlot();
end

plot(q, y(:, 3), 'DisplayName', 'S-mat');
yyaxis right
plot(q, y(:, 1), 'DisplayName', 'T11')
% hold on
% plot(q, y(:, 2), 'DisplayName', 'T21')
legend()