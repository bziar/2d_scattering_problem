clear; close all; clc;
% warning off all;

%% Параметры системы
M = 10;                % Максимальное гармоническое число
M1 = 5;
N = 3;                 % Количество частиц
r = 0.5;              % Базовый радиус частиц

%% Настройка физических параметров
SYSTEM.r = r;
SYSTEM.M = M;
SYSTEM.M1 = M1;
SYSTEM.N = N;
SYSTEM.n1 = 1;
SYSTEM.n2 = 3.5;
SYSTEM.types = 0*ones(1, N);
% SYSTEM.types(1:1) = 1 + SYSTEM.types(1:1);
SYSTEM.N_asph = sum(SYSTEM.types);
SYSTEM.optCoefNums = [2, 5];
SYSTEM.paramsNum = N - SYSTEM.N_asph + ... радиусы
    2 * N + ... смещения
    SYSTEM.N_asph * numel(SYSTEM.optCoefNums); ... коэффицинты
    
% Начальные координаты частиц
SYSTEM.coordinates = startPosition(N, 3 * r);
% SYSTEM.coordinates{1} = [-2.5, 0];
% SYSTEM.coordinates{2} = [2.5, 0];
% SYSTEM.coordinates = {[0,0]};

% Матрицы проекции для целевых направлений излучения
SYSTEM.Q = (qMatrix(M, pi/2-pi/4, pi/4));          % Основное направление

%% Расчет эталонных полей для одиночной сферы
test = SphericalScatterer(...
    'sizeParam', r, ...
    'refrIndexOut', SYSTEM.n1, ...
    'refrIndexIn', SYSTEM.n2, ...
    'maxHarmNum', SYSTEM.M);
test.Calculate();
test.SetIncField('gauss');
SYSTEM.gauss2 = test.incCoeffs;      % Коэффициенты падающего поля
test.scaCoeffs = 0 * test.scaCoeffs;
test.intCoeffs = 0 * test.scaCoeffs;

%% INITIALIZATION
SYSTEM.particles = cell(1, SYSTEM.N_asph);
SYSTEM.oldCoeffs = cell(1, SYSTEM.N_asph);

for k = 1:SYSTEM.N_asph
    SYSTEM.particles{k} = AsphericalScatterer(...
        'sizeParam', r, ...
        'refrIndexOut', SYSTEM.n1, ...
        'refrIndexIn', SYSTEM.n2, ...
        'maxHarmNum', SYSTEM.M1, ...
        'maxPertStep', 2, ...
        'maxShapeCoeffsNum', 4, ...
        'shapeGridSize', 2^10+1);
    SYSTEM.particles{k}.Init();
    SYSTEM.particles{k}.SetIncField('planewave');
    SYSTEM.oldCoeffs{k} = SYSTEM.particles{k}.shapeCoeffs;
    SYSTEM.particleType(k) = "aspherical";
    SYSTEM.errors{k} = [];
end

% initial_params = 0.0 * randn(4 * N, 1);
% fun = @(x) targetFunction(SYSTEM, x);
% check_gradient(fun, initial_params);
% return

%% Запуск многократной оптимизации с разными начальными условиями
fprintf('=== ЗАПУСК ОПТИМИЗАЦИИ ===\n');
fprintf('Время старта: %s\n', datestr(now));

% Сохраняем состояние генератора случайных чисел
rng_state = rng();
save('last_run_rng.mat', 'rng_state');

% Количество запусков с разными начальными параметрами
num_runs = 1;
best_overall_params = [];
best_overall_value = inf;
all_results = cell(num_runs, 1);

% Настройки градиентного спуска (общие для всех запусков)
options = struct();
options.method = 'adam';
options.learning_rate = 3e-2;
options.max_iterations = 10;
options.beta1 = 0.9;
options.beta2 = 0.999;
options.plateau_patience = 10;
options.noise_scale = 0.01;
options.gradient_clip = 1.0;

% Ограничения на параметры
options.bounds = zeros(2, SYSTEM.paramsNum);
for i = 1:N - SYSTEM.N_asph
    options.bounds(1, i) = -0.6;    % Минимальный радиус
    options.bounds(2, i) = 0.1;     % Максимальный радиус
end
for i = N - SYSTEM.N_asph + 1:3*N - SYSTEM.N_asph
    options.bounds(1, i) = -0.5;     % Минимальное смещение
    options.bounds(2, i) = 0.5;      % Максимальное смещение
end
for i = 3*N - SYSTEM.N_asph + 1:SYSTEM.paramsNum
    options.bounds(1, i) = -0.2;     % Минимальное изменение формы
    options.bounds(2, i) = 0.2;      % Максимальное изменение формы
end


%% Цикл по разным начальным параметрам
final_run = 0;
for run = 1:num_runs
    % if (str2num(datestr(now, 'MM')) >= 60)
    %     fprintf('ВРЕМЯ ВЫШЛО!');
    %     final_run = run-1;
    %     break;
    % end
    fprintf('\n--- ЗАПУСК %d из %d ---\n', run, num_runs);
    
    % Генерируем разные начальные параметры
    if run == 1
        % Первый запуск - нулевые параметры (все частицы на местах)
        initial_params = zeros(SYSTEM.paramsNum, 1);
        [~, ~, SYSTEM] = targetFunction(SYSTEM, initial_params, true);
        % initial_params = 0.01 * randn(4 * N, 1);
        % fun = @(x) targetFunction(SYSTEM, x);
        % check_gradient(fun, initial_params);
        % return
        
    else
        % Последующие запуски - случайные параметры с разным масштабом
        scale = 0.01 * run;  % Увеличиваем разброс с каждым запуском
        initial_params = scale * randn(SYSTEM.paramsNum, 1);
    end
    
    % Применяем ограничения к начальным параметрам

    initial_params = max(options.bounds(1, :).', ...
        min(options.bounds(2, :).', initial_params));
    
    fprintf('Начальное значение функции: %.6e\n', ...
        targetFunction(SYSTEM, initial_params));
    
    % Запускаем градиентный спуск
    tic;
    [optimal_params, history, SYSTEM] = gradientDescentImproved(SYSTEM, initial_params, options, @targetFunction);
    elapsed_time = toc;
    
    % Вычисляем финальное значение функции
    [final_value, ~, SYSTEM] = targetFunction(SYSTEM, optimal_params, false);
    targetFunction(SYSTEM, optimal_params, true);
    
    % Сохраняем результаты
    all_results{run} = struct(...
        'params', optimal_params, ...
        'initial_params', initial_params, ...
        'final_value', final_value, ...
        'history', history, ...
        'time', elapsed_time);
    
    fprintf('Запуск %d завершен за %.2f сек, финальное значение: %.6e\n', ...
        run, elapsed_time, final_value);
    
    % Обновляем лучшее глобальное решение
    if final_value < best_overall_value
        best_overall_value = final_value;
        best_overall_params = optimal_params;
        fprintf('>>> НОВОЕ ЛУЧШЕЕ РЕШЕНИЕ! <<<\n');
    end
    final_run = run;
end
temp = all_results;
clear all_results;

all_results = cell(final_run, 1);
for i = 1:final_run
    all_results{i} = temp{i};
end
clear temp;

% all_results = all_results{1:final_run};
%% Анализ и визуализация результатов
fprintf('\n=== РЕЗУЛЬТАТЫ ОПТИМИЗАЦИИ ===\n');
fprintf('Лучшее значение функции: %.6e\n', best_overall_value);

% Визуализация истории сходимости для всех запусков
figure('Name', 'Сравнение запусков', 'Position', [100, 100, 1200, 800]);

% График значений функции
subplot(2, 2, 1);
hold on;
colors = lines(final_run);
for run = 1:final_run
    plot(all_results{run}.history.f_values, 'Color', colors(run, :), ...
        'LineWidth', 0.2, 'DisplayName', sprintf('Запуск %d', run));
end
xlabel('Итерация');
ylabel('Значение функции');
title('Сходимость для разных запусков');
% legend('show', 'Location', 'best');
grid on;

% График норм градиента
subplot(2, 2, 2);
hold on;
for run = 1:final_run
    plot(all_results{run}.history.grad_norms, 'Color', colors(run, :), ...
        'LineWidth', 0.2);
end
xlabel('Итерация');
ylabel('Норма градиента');
title('Норма градиента');
set(gca, 'YScale', 'log');
grid on;

% Сравнение финальных значений
subplot(2, 2, 3);
final_values = cellfun(@(x) x.final_value, all_results);
bar(final_values);
xlabel('Номер запуска');
ylabel('Финальное значение функции');
title('Сравнение финальных значений');
grid on;

% Время выполнения
subplot(2, 2, 4);
times = cellfun(@(x) x.time, all_results);
bar(times);
xlabel('Номер запуска');
ylabel('Время выполнения (сек)');
title('Время оптимизации');
grid on;


%% Финальная визуализация лучшего решения
fprintf('\n=== ФИНАЛЬНАЯ ВИЗУАЛИЗАЦИЯ ===\n');

% Отображаем геометрию лучшего решения
plotGeometry(SYSTEM, best_overall_params);

% Вычисляем и отображаем целевую функцию для лучшего решения
% figure('Name', 'Целевая функция для лучшего решения');
targetFunction(SYSTEM, best_overall_params, true);
title(sprintf('Лучшее решение (значение: %.4e)', best_overall_value));
disp(best_overall_params)
fprintf('Оптимизация завершена. Результаты сохранены в best_solution2.mat\n');

%% Целевая функция
function [y, grad, SYSTEM] = targetFunction(SYSTEM, params, draw)

if nargin < 3
    draw = false;
end

N = SYSTEM.N;
M = SYSTEM.M;
M1 = SYSTEM.M1;


ns = numel(SYSTEM.optCoefNums);

% Инициализация
coord = cell(1, N);
scaMatrices = cell(1, N);
scaMatricesSPH_der = cell(1, N-SYSTEM.N_asph);
scaMatricesASPH_der = cell(1, ns*SYSTEM.N_asph);
angles = cell(1, N);
grad = zeros(numel(params), 1);
y = 0;

nRad = N-SYSTEM.N_asph;
radii = SYSTEM.r * (1 + params(1:nRad));
shifts = SYSTEM.r * params(nRad+1:nRad+2*N);
shape_params = params(nRad+2*N+1:end);
% disp(shape_params)

n1 = SYSTEM.n1;
n2 = SYSTEM.n2;
scale = 1;

nAsph = 1;
nSph = 1;
for k = 1:N
    if SYSTEM.types(k) == 1
        parVal = shape_params(ns*(nAsph-1)+1:ns*nAsph);
        newCoeffs = zeros(size(SYSTEM.particles{nAsph}.shapeCoeffs));
        newCoeffs(SYSTEM.optCoefNums) = parVal;
        SYSTEM.particles{nAsph}.PerturbFull(newCoeffs - SYSTEM.oldCoeffs{nAsph}, 4);
        err = SYSTEM.particles{nAsph}.CheckCondition(false);
        SYSTEM.errors{nAsph} = [SYSTEM.errors{nAsph}, err];
        SYSTEM.particles{nAsph}.ShapeUpdate(newCoeffs);
        % SYSTEM.particles{nAsph}.CheckCondition();
        SYSTEM.oldCoeffs{nAsph} = newCoeffs;
        scaMatrices{k} = SYSTEM.particles{nAsph}.scaMatrix;
        SYSTEM.particles{nAsph}.GradientCalc();
        
        for s = 1:ns
            scaMatricesASPH_der{ns*(nAsph-1) + s} = SYSTEM.particles{nAsph}.gradients{s};
        end
        nAsph = nAsph + 1;
    else
        test = SphericalScatterer(...
            'sizeParam', scale * radii(nSph), ...
            'refrIndexOut', n1, ...
            'refrIndexIn', n2, ...
            'maxHarmNum', SYSTEM.M1);
        test.Calculate();
        
        scaMatrices{k} = test.scaMatrix;
        scaMatricesSPH_der{nSph} = test.scaMatrix_der;
        nSph = nSph + 1;
    end
    
    coord{k} = SYSTEM.coordinates{k} + [shifts(2*k-1); shifts(2*k)];
    coord{k} = scale * coord{k};
    angles{k} = 0;
end

scaMatrices_der = [scaMatricesSPH_der, scaMatricesASPH_der];


% Создаем мультисистему
mTest = MultiSystem(...
    'sizeParam', SYSTEM.r, ...
    'refrIndexOut', n1, ...
    'maxHarmNum', M, ...
    'maxHarmNum1', M1, ...
    'numParticles', N, ...
    'coordinates', coord, ...
    'angles', angles, ...
    'scaMatrices', scaMatrices, ...
    'scaMatrices_der', scaMatrices_der, ...
    'nAsphPart', SYSTEM.N_asph, ...
    'nAsphCoeffs', ns);

% mTest.SetIncField('planewave');
mTest.SetIncField('other', SYSTEM.gauss2);
mTest.Q = SYSTEM.Q;
mTest.Calculate6();

if draw
    mTest.FarFieldPlot();
end


y = y + 1 / real(mTest.targetFunc);

for p = 1:SYSTEM.paramsNum
    if p <= N - SYSTEM.N_asph + 2 * N
        scale = SYSTEM.r;
    else
        scale = 5e-9;
    end
    grad(p) = grad(p) - scale * (2 * real(mTest.scaMatrix_der{p})) / (real(mTest.targetFunc))^2;
end
end

