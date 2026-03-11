%% Основной скрипт оптимизации расположения частиц
% Оптимизирует положения и радиусы N частиц для формирования заданной
% диаграммы направленности с использованием градиентного спуска

clear; close all; clc;

%% Параметры системы
M = 18;                 % Максимальное гармоническое число
N = 20;                 % Количество частиц
r = 0.65;               % Базовый радиус частиц

%% Настройка физических параметров
SYSTEM.r = r;
SYSTEM.M = M;
SYSTEM.N = N;
SYSTEM.n1 = 1.;       % Показатель преломления окружающей среды
SYSTEM.n2 = 2.81;       % Показатель преломления материала частиц

% Начальные координаты частиц (треугольная решетка)
SYSTEM.coordinates = startPosition(N, 2.5 * r);

% Матрицы проекции для целевых направлений излучения
SYSTEM.Q = (qMatrix(M, -pi/2-pi/4, pi/12));          % Основное направление
SYSTEM.Q2 = (qMatrix(M, -pi/2+pi/4, pi/12));  % Дополнительное направление

% Псевдообратная матрица для проекции
SYSTEM.Q_ = pinv(SYSTEM.Q.' * SYSTEM.Q) * SYSTEM.Q.';
SYSTEM.proj = (eye(2 * M + 1) - SYSTEM.Q * SYSTEM.Q_);

%% Расчет эталонных полей для одиночной сферы
% Основная сфера
% 1.1832 * 
test = SphericalScatterer(...
    'sizeParam', r, ...
    'refrIndexOut', SYSTEM.n1, ...
    'refrIndexIn', SYSTEM.n2, ...
    'maxHarmNum', SYSTEM.M);
test.Calculate();
test.SetIncField('gauss');
SYSTEM.gauss = test.incCoeffs;      % Коэффициенты падающего поля

% Увеличенная сфера для дополнительного направления
test = SphericalScatterer(...
    'sizeParam', r, ...
    'refrIndexOut', SYSTEM.n1, ...
    'refrIndexIn', SYSTEM.n2, ...
    'maxHarmNum', SYSTEM.M);
test.Calculate();
test.SetIncField('gauss');
SYSTEM.gauss2 = test.incCoeffs;     % Коэффициенты для второго направления
clear test;

%% Запуск многократной оптимизации с разными начальными условиями
fprintf('=== ЗАПУСК ОПТИМИЗАЦИИ ===\n');
fprintf('Время старта: %s\n', datestr(now));

% Сохраняем состояние генератора случайных чисел
rng_state = rng();
save('last_run_rng.mat', 'rng_state');

% Количество запусков с разными начальными параметрами
num_runs = 50;
best_overall_params = [];
best_overall_value = inf;
all_results = cell(num_runs, 1);

% Настройки градиентного спуска (общие для всех запусков)
options = struct();
options.method = 'adam';
options.learning_rate = 0.1;
options.max_iterations = 120;
options.beta1 = 0.9;
options.beta2 = 0.999;
options.plateau_patience = 10;
options.noise_scale = 0.01;
options.gradient_clip = 1.0;

% Ограничения на параметры
options.bounds = zeros(2, 3 * N - 2);
for i = 1:N
    options.bounds(1, i) = -0.9;    % Минимальный радиус
    options.bounds(2, i) = 0.3;     % Максимальный радиус
end
for i = N + 1:3 * N - 2
    options.bounds(1, i) = -0.4;     % Минимальное смещение
    options.bounds(2, i) = 0.4;      % Максимальное смещение
end

%% Цикл по разным начальным параметрам
final_run = 0;
for run = 1:num_runs
    if (str2num(datestr(now, 'MM')) >= 6)
        fprintf('ВРЕМЯ ВЫШЛО!');
        final_run = run-1;
        break;
    end
    fprintf('\n--- ЗАПУСК %d из %d ---\n', run, num_runs);
    
    % Генерируем разные начальные параметры
    if run == 1
        % Первый запуск - нулевые параметры (все частицы на местах)
        initial_params = zeros(3 * N - 2, 1);
    else
        % Последующие запуски - случайные параметры с разным масштабом
        scale = 0.5 * run;  % Увеличиваем разброс с каждым запуском
        initial_params = scale * randn(3 * N - 2, 1);
    end
    
    % Применяем ограничения к начальным параметрам
    initial_params = max(options.bounds(1, :).', ...
        min(options.bounds(2, :).', initial_params));
    
    fprintf('Начальное значение функции: %.6e\n', ...
        targetFunction(SYSTEM, initial_params));
    
    % Запускаем градиентный спуск
    tic;
    [optimal_params, history] = gradientDescentImproved(SYSTEM, initial_params, options);
    elapsed_time = toc;
    
    % Вычисляем финальное значение функции
    final_value = targetFunction(SYSTEM, optimal_params);
    
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

% Сохраняем лучшее решение
save('best_solution.mat', 'best_overall_params', 'best_overall_value', 'all_results');

%% Финальная визуализация лучшего решения
fprintf('\n=== ФИНАЛЬНАЯ ВИЗУАЛИЗАЦИЯ ===\n');

% Отображаем геометрию лучшего решения
plotGeometry(SYSTEM, best_overall_params);

% Вычисляем и отображаем целевую функцию для лучшего решения
figure('Name', 'Целевая функция для лучшего решения');
targetFunction(SYSTEM, best_overall_params, true);
title(sprintf('Лучшее решение (значение: %.4e)', best_overall_value));

fprintf('Оптимизация завершена. Результаты сохранены в best_solution.mat\n');

%% Целевая функция
function [y, grad] = targetFunction(SYSTEM, params, draw)
    % Целевая функция для оптимизации
    % Вход:
    %   SYSTEM - структура с параметрами системы
    %   params - вектор параметров [радиусы; смещения]
    %   draw - флаг визуализации (опционально)
    % Выход:
    %   y - значение целевой функции
    %   grad - градиент целевой функции
    
    if nargin < 3
        draw = false;
    end
    
    N = SYSTEM.N;
    M = SYSTEM.M;
    
    % Извлекаем параметры
    radii = SYSTEM.r * (1 + params(1:N));
    shifts = [zeros(2, 1); SYSTEM.r * params(N+1:end)];
    
    % Коэффициент масштабирования для второго направления
    ChangeCoeff = 1.1832*0 + 1;
    
    % Инициализация
    coord = cell(1, N);
    scaMatrices = cell(1, N);
    scaMatrices_der = cell(1, N);
    angles = cell(1, N);
    grad = zeros(numel(params), 1);
    y = 0;
    
    % Цикл по двум масштабам (основной и дополнительный)
    for scale = [ChangeCoeff]
        for k = 1:N
            % Создаем рассеиватель для каждой частицы
            test = SphericalScatterer(...
                'sizeParam', scale * radii(k), ...
                'refrIndexOut', SYSTEM.n1, ...
                'refrIndexIn', real(SYSTEM.n2) + imag(SYSTEM.n2), ...
                'maxHarmNum', SYSTEM.M);
            test.Calculate();
            
            scaMatrices{k} = test.scaMatrix;
            scaMatrices_der{k} = test.scaMatrix_der;
            
            % Координаты частицы с учетом смещения и масштаба
            coord{k} = SYSTEM.coordinates{k} + [shifts(2*k-1); shifts(2*k)];
            coord{k} = scale * coord{k};
            angles{k} = 0;
        end
        
        % Создаем мультисистему
        mTest = MultiSystem(...
            'sizeParam', sqrt(N) * SYSTEM.r, ...
            'refrIndexOut', SYSTEM.n1, ...
            'maxHarmNum', M, ...
            'numParticles', N, ...
            'coordinates', coord, ...
            'angles', angles, ...
            'scaMatrices', scaMatrices, ...
            'scaMatrices_der', scaMatrices_der);
        
        % Устанавливаем падающее поле
        if scale == ChangeCoeff
            mTest.SetIncField('other', SYSTEM.gauss2);
        else
            mTest.SetIncField('other', SYSTEM.gauss);
        end
        
        mTest.Calculate2();
        
        % Визуализация при необходимости
        if draw
            if scale == ChangeCoeff
                ax = mTest.FarFieldPlot();
                hold(ax, 'on');
            else
                mTest.FarFieldPlot(ax);
            end
        end
        
        % Вычисление целевой функции
        a = mTest.scaCoeffs .* exp(-1j * (-M:M).' * pi - pi/4);
        
        if scale == ChangeCoeff
            Q = SYSTEM.Q;
        else
            Q = SYSTEM.Q2;
        end
        
        nrm = (a' * a);
        y1 = real((a' * Q * a) / nrm);
        y = y - y1;  % Минимизируем отрицательное значение
        
        % Вычисление градиента
        for p = 1:3*N-2
            if p > N
                k = p + 2;
            else
                k = p;
            end
            
            a_der = scale * SYSTEM.r * mTest.scaMatrix_der{k} ./ ...
                exp(-1j * (-M:M).' * pi - pi/4);
            
            grad(p) = grad(p) - real(...
                (a_der' * Q * a + a' * Q * a_der) * nrm - ...
                (a' * Q * a) * (a_der' * a + a' * a_der) ...
                ) / nrm^2;
        end
    end
end

%% Улучшенный градиентный спуск
function [optimal_params, history] = gradientDescentImproved(SYSTEM, initial_params, options)
    % Улучшенный градиентный спуск с адаптивными методами оптимизации
    %
    % Вход:
    %   SYSTEM - структура с параметрами системы
    %   initial_params - начальные параметры
    %   options - структура с настройками
    %
    % Выход:
    %   optimal_params - оптимальные параметры
    %   history - история оптимизации
    
    % Параметры по умолчанию
    default_options = struct(...
        'method', 'adam', ...
        'learning_rate', 0.1, ...
        'max_iterations', 1000, ...
        'max_function_evals', 5000, ...
        'tolerance', 1e-4, ...
        'grad_tolerance', 1e-6, ...
        'verbose', true, ...
        'verbose_freq', 2, ...
        'momentum', 0.9, ...
        'beta1', 0.9, ...
        'beta2', 0.999, ...
        'epsilon', 1e-8, ...
        'gradient_clip', 1.0, ...
        'use_nesterov', true, ...
        'restart_threshold', 5, ...
        'plateau_patience', 20, ...
        'plateau_factor', 0.5, ...
        'bounds', [], ...
        'noise_scale', 0.0 ...
        );
    
    % Заполнение пропущенных опций
    if nargin < 3
        options = default_options;
    else
        fields = fieldnames(default_options);
        for i = 1:length(fields)
            if ~isfield(options, fields{i})
                options.(fields{i}) = default_options.(fields{i});
            end
        end
    end
    
    % Инициализация
    params = initial_params(:);
    n_params = length(params);
    best_params = params;
    best_value = Inf;
    
    % История
    history.f_values = [];
    history.grad_norms = [];
    history.params_history = [];
    history.learning_rates = [];
    history.method = options.method;
    
    % Инициализация для разных методов
    switch lower(options.method)
        case 'momentum'
            velocity = zeros(size(params));
        case 'nesterov'
            velocity = zeros(size(params));
        case 'adagrad'
            G = zeros(size(params));
        case 'rmsprop'
            E_g = zeros(size(params));
        case 'adam'
            m = zeros(size(params));
            v = zeros(size(params));
            t = 0;
    end
    
    % Для отслеживания плато
    plateau_counter = 0;
    best_value_plateau = Inf;
    func_evals = 0;
    
    % Основной цикл
    for iter = 1:options.max_iterations
        % Вычисление функции и градиента
        [current_value, gradient] = targetFunction(SYSTEM, params);
        func_evals = func_evals + 1;
        
        % Проверка на NaN
        if any(isnan(gradient)) || isnan(current_value)
            warning('Обнаружен NaN на итерации %d', iter);
            break;
        end
        
        grad_norm = norm(gradient);
        
        % Сохранение истории
        history.f_values(end+1) = current_value;
        history.grad_norms(end+1) = grad_norm;
        history.params_history(:, end+1) = params;
        history.learning_rates(end+1) = options.learning_rate;
        
        % Обновление лучшего решения
        if current_value < best_value
            best_value = current_value;
            best_params = params;
        end
        
        % Вывод информации
        if options.verbose && (mod(iter, options.verbose_freq) == 0 || iter == 1)
            fprintf('Итер %4d: f=%.4e (лучш:%.4e), |∇f|=%.2e, lr=%.4f\n', ...
                iter, current_value, best_value, grad_norm, options.learning_rate);
        end
        
        % Критерии остановки
        if grad_norm < options.grad_tolerance
            break;
        end
        
        if iter > 1
            rel_change = abs(history.f_values(end) - history.f_values(end-1)) / ...
                (abs(history.f_values(end-1)) + options.epsilon);
            if rel_change < options.tolerance
                break;
            end
        end
        
        % Обработка плато
        if current_value > best_value_plateau - 1e-6
            plateau_counter = plateau_counter + 1;
        else
            plateau_counter = 0;
            best_value_plateau = current_value;
        end
        
        if plateau_counter >= options.plateau_patience
            options.learning_rate = options.learning_rate * options.plateau_factor;
            plateau_counter = 0;
            
            if options.noise_scale > 0
                params = params + options.noise_scale * randn(size(params));
            end
        end
        
        % Обрезание градиента
        if options.gradient_clip > 0 && grad_norm > options.gradient_clip
            gradient = gradient * options.gradient_clip / grad_norm;
        end
        
        % Обновление параметров в зависимости от метода
        switch lower(options.method)
            case 'sgd'
                params = params - options.learning_rate * gradient;
                
            case 'momentum'
                velocity = options.momentum * velocity - options.learning_rate * gradient;
                params = params + velocity;
                
            case 'nesterov'
                if options.use_nesterov && iter > 1
                    params_nesterov = params + options.momentum * velocity;
                    [~, grad_nesterov] = targetFunction(SYSTEM, params_nesterov);
                    func_evals = func_evals + 1;
                    velocity = options.momentum * velocity - options.learning_rate * grad_nesterov;
                else
                    velocity = options.momentum * velocity - options.learning_rate * gradient;
                end
                params = params + velocity;
                
            case 'adagrad'
                G = G + gradient.^2;
                params = params - options.learning_rate * gradient ./ (sqrt(G) + options.epsilon);
                
            case 'rmsprop'
                E_g = options.beta2 * E_g + (1 - options.beta2) * gradient.^2;
                params = params - options.learning_rate * gradient ./ (sqrt(E_g) + options.epsilon);
                
            case 'adam'
                t = t + 1;
                m = options.beta1 * m + (1 - options.beta1) * gradient;
                v = options.beta2 * v + (1 - options.beta2) * gradient.^2;
                
                m_hat = m / (1 - options.beta1^t);
                v_hat = v / (1 - options.beta2^t);
                
                params = params - options.learning_rate * m_hat ./ (sqrt(v_hat) + options.epsilon);
        end
        
        % Применение ограничений
        if ~isempty(options.bounds)
            params = max(options.bounds(1, :).', min(options.bounds(2, :).', params));
        end
        
        % Проверка на превышение числа вычислений
        if func_evals >= options.max_function_evals
            break;
        end
    end
    
    optimal_params = best_params;
end