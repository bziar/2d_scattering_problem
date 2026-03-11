marr = 1:20;
% marr = 5;
yarr = 0*marr;
tic
for mmm = 15
% disp(mmm)
%% Параметры системы
M = 20;                % Максимальное гармоническое число
M1 = mmm;
r = 3;              % Базовый радиус частиц
c = 0.1;

SYSTEM.r = r;
SYSTEM.M = M;
SYSTEM.M1 = M1;
SYSTEM.n1 = 1;       % Показатель преломления окружающей среды
SYSTEM.n2 = 3;       % Показатель преломления материала частиц

test = AsphericalScatterer(...
    'sizeParam', r, ...
    'refrIndexOut', SYSTEM.n1, ...
    'refrIndexIn', SYSTEM.n2, ...
    'maxHarmNum', SYSTEM.M1, ...
    'maxPertStep', 4, ...
    'maxShapeCoeffsNum', 2, ...
    'shapeGridSize', 2^14+1);
test.Init();
test.SetIncField('planewave');
% test.FarFieldPlot;
% testCoeffs = [zeros(1, 6), 0, -0.02];
testCoeffs = [zeros(1, 2), 0, -0.05];
test.perturbStep(testCoeffs);
return
test.FarFieldPlot;
% return
test.ShapeUpdate(testCoeffs);
test.EBCM();
test.FarFieldPlot;
test.ShapePlot();
return
test = SphericalScatterer(...
    'sizeParam', r, ...
    'refrIndexOut', SYSTEM.n1, ...
    'refrIndexIn', SYSTEM.n2, ...
    'maxHarmNum', SYSTEM.M1, ...
    'maxPertStep', 10, ...
    'maxShapeCoeffsNum', 5, ...
    'shapeGridSize', 2^10+1);
test.Calculate();
test.SetIncField('planewave');
test.FarFieldPlot;


% test.ShapeUpdate();
% FUNCTIONS = test.functionCalc();
% 
% alpha_arr_1 = FUNCTIONS.alpha_arr_1;
% alpha_arr_2 = FUNCTIONS.alpha_arr_2;
% beta_arr = FUNCTIONS.beta_arr;
% eta_arr_1 = FUNCTIONS.eta_arr_1;
% eta_arr_2 = FUNCTIONS.eta_arr_2;
% sigma_arr = FUNCTIONS.sigma_arr;
% phi_arr = FUNCTIONS.phi_arr;



% test.ShapeDecomposition();
% m1 = test.shapeDecompMat;
test.ShapeDecomposition();
% m2 = test.shapeDecompMat;

% plot(abs(m1(:))-abs(m2(:)), 'LineWidth', 1);
% hold on
% plot(abs(m2(:)), '--', 'LineWidth', 1);
% return
% test.ShapeUpdate([0, 0, 0.5, 0, 0, 0, 0, -0.15]);
% test.EBCM();
% test.ShapePlot();
% test.FarFieldPlot();

% test.oldEBCM();
% test.ShapePlot();
% test.FarFieldPlot();
% yarr(mmm) = norm(test.scaCoeffs);


end
toc
% plot(marr, yarr)