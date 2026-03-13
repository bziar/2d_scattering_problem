clc; clear all; close all;

marr = 1:20;
% marr = 5;
yarr = 0*marr;
tic


%% Параметры системы
M = 15;                
M1 = 8;
r = 1;              
c = 0.1;

SYSTEM.r = r;
SYSTEM.M = M;
SYSTEM.M1 = M1;
SYSTEM.n1 = 1.5;       % Показатель преломления окружающей среды
SYSTEM.n2 = 3.5;       % Показатель преломления материала частиц

test = AsphericalScatterer(...
    'sizeParam', r, ...
    'refrIndexOut', SYSTEM.n1, ...
    'refrIndexIn', SYSTEM.n2, ...
    'maxHarmNum', SYSTEM.M1, ...
    'maxPertStep', 2, ...
    'maxShapeCoeffsNum', 4, ...
    'shapeGridSize', 2^11+1);
test.Init();
test.SetIncField('planewave');
test.CheckCondition();

testCoeffs = [zeros(1, 4), -0.2, -0.1, 0.25, -0.15];
tic
test.PerturbFull(testCoeffs, 30);
toc
% test.SetIncField('planewave');
% test.FarFieldPlot;
test.ShapeUpdate(testCoeffs);
% tic
% test.EBCM();
% test.CheckCondition();
% toc
test.FarFieldPlot;
% test.FarFieldPlot;
% test.ShapePlot();

scaM = test.scaMatrix;

mTest = MultiSystem(...
    'sizeParam', r, ...
    'refrIndexOut', SYSTEM.n1, ...
    'maxHarmNum', M, ...
    'maxHarmNum1', M1, ...
    'numParticles', 4, ...
    'coordinates', {[-2; -2], [-2; 2], [2; 2], [2; -2]}, ...
    'angles', {0, 0, 0, 0}, ...
    'scaMatrices', {scaM, scaM, scaM, scaM}, ...
    'scaMatrices_der', {0*scaM, 0*scaM, 0*scaM, 0*scaM});

mTest.SetIncField('planewave');
mTest.Q = zeros(2*M+1);
mTest.Calculate4(false);
ax = mTest.FarFieldPlot();


return
