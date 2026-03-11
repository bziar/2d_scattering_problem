
M = 20;
N = 36;
r = 1.5;

% radii = cell(1, N);
% shifts = cell(1, N);

% for k = 1:N
%     radii{k} = 0;
%     shifts{k} = [0; 0];
% end

SYSTEM.r = r;
SYSTEM.M = M;
SYSTEM.N = N;
SYSTEM.n1 = 1;
SYSTEM.n2 = 1.75;
SYSTEM.coordinates = startPosition(N, 3*r);
SYSTEM.Q = qMatrix(M, pi/3+pi, pi/12);
SYSTEM.Q_ = (SYSTEM.Q.'*SYSTEM.Q)\SYSTEM.Q.';
SYSTEM.proj = (eye(2*M+1) - SYSTEM.Q * SYSTEM.Q_) / sqrt(norm(SYSTEM.Q * SYSTEM.Q_));


test = SphericalScatterer(...
    'sizeParam', 1, ...
    'refrIndexOut', SYSTEM.n1, ...
    'refrIndexIn', SYSTEM.n2, ...
    'maxHarmNum', SYSTEM.M);
test.SetIncField('gauss');
test.FarFieldPlot();
SYSTEM.gauss = test.incCoeffs;
clear test;

initial_params = zeros(1, N);
optimal_params = initial_params;
[optimal_params, history] = gradientDescent(SYSTEM, initial_params);
targetFunction(SYSTEM, optimal_params, true)

function [y, grad] = targetFunction(SYSTEM, params, draw)
if nargin < 3
    draw = false;
end
N = SYSTEM.N;
M = SYSTEM.M;
radii = SYSTEM.r * (1+params(1:N));
% shifts = SYSTEM.r * params(N+1:end);
coord = cell(1, N);
scaMatrices = cell(1, N);
scaMatrices_der = cell(1, N);
angles = cell(1, N);

for k = 1:N
    test = SphericalScatterer(...
        'sizeParam', radii(k), ...
        'refrIndexOut', SYSTEM.n1, ...
        'refrIndexIn', SYSTEM.n2, ...
        'maxHarmNum', SYSTEM.M);
    test.Calculate();
    scaMatrices{k} = test.scaMatrix;
    scaMatrices_der{k} = test.scaMatrix_der;
    % coord{k} = SYSTEM.coordinates{k} + shifts(2*k-1:2*k);
    coord{k} = SYSTEM.coordinates{k};
    angles{k} = 0;
end

mTest = MultiSystem(...
    'sizeParam', sqrt(N) * SYSTEM.r, ...
    'refrIndexOut', SYSTEM.n1, ...
    'maxHarmNum', M, ...
    'numParticles', N, ...
    'coordinates', coord, ...
    'angles', angles, ...
    'scaMatrices', scaMatrices, ...
    'scaMatrices_der', scaMatrices_der);
% mTest.CalcIterative(300);
mTest.SetIncField('other', SYSTEM.gauss);
mTest.Calculate();


if draw
    mTest.FarFieldPlot();
end

vec_der = cell(1, numel(params));

vec = SYSTEM.proj * mTest.scaCoeffs;
y = (vec' * vec);
grad = zeros(numel(params), 1);
% Вычисляем производные в cell array
for p = 1:numel(params)
    vec_der{p} = radii(k) * SYSTEM.proj * mTest.scaMatrix_der{p};
    grad(p) = vec_der{p}' * vec + vec' * vec_der{p};
end

end









function [optimal_params, history] = gradientDescent(SYSTEM, initial_params, options)
% Градиентный спуск для оптимизации параметров рассеивающей системы
%
% Входные параметры:
%   SYSTEM - структура с параметрами системы
%   initial_params - начальные параметры [радиусы; смещения]
%   options - структура с настройками оптимизации
%
% Выходные параметры:
%   optimal_params - оптимальные параметры
%   history - история оптимизации

% Параметры по умолчанию
default_options = struct(...
    'learning_rate', 0.01, ...      % Начальная скорость обучения
    'max_iterations', 300, ...     % Максимальное число итераций
    'tolerance', 1e-9, ...          % Критерий остановки по изменению функции
    'grad_tolerance', 1e-8, ...     % Критерий остановки по норме градиента
    'verbose', true, ...            % Вывод информации о процессе
    'momentum', 0.95, ...            % Коэффициент момента
    'decay_rate', 0.97, ...         % Скорость затухания learning rate
    'decay_step', 50, ...          % Шаги для уменьшения learning rate
    'gradient_clip', 5, ...        % Максимальное значение градиента (clipping)
    'use_line_search', false, ...   % Использовать поиск по линии
    'history_size', 50 ...          % Размер истории для критерия остановки
    );

% Заполнение недостающих опций значениями по умолчанию
if nargin < 3
    options = default_options;
else
    option_fields = fieldnames(default_options);
    for i = 1:length(option_fields)
        if ~isfield(options, option_fields{i})
            options.(option_fields{i}) = default_options.(option_fields{i});
        end
    end
end

% Инициализация
params = initial_params(:);  % Преобразуем в вектор-столбец
velocity = zeros(size(params));  % Для момента
best_params = params;
best_value = Inf;

% История оптимизации
history.f_values = [];
history.grad_norms = [];
history.params_history = [];
history.learning_rates = [];

% Основной цикл оптимизации
if options.verbose
    fprintf('Начало градиентного спуска...\n');
    fprintf('Размерность задачи: %d\n', length(params));
end

for iter = 1:options.max_iterations
    % Вычисление целевой функции и градиента
    [current_value, gradient] = targetFunction(SYSTEM, params);
    
    % Проверка на NaN
    if any(isnan(gradient)) || isnan(current_value)
        warning('NaN обнаружен на итерации %d', iter);
        break;
    end
    
    % Норма градиента
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
    if options.verbose && (mod(iter, 10) == 0 || iter == 1)
        fprintf('Итерация %4d: f = %.6e, ||∇f|| = %.6e, lr = %.6e\n', ...
            iter, current_value, grad_norm, options.learning_rate);
    end
    
    % Критерии остановки
    if grad_norm < options.grad_tolerance
        if options.verbose
            fprintf('Остановка: норма градиента ниже порога (%.1e)\n', options.grad_tolerance);
        end
        break;
    end
    
    if iter > 1
        f_change = abs(history.f_values(end) - history.f_values(end-1));
        if f_change < options.tolerance
            if options.verbose
                fprintf('Остановка: изменение функции ниже порога (%.1e)\n', options.tolerance);
            end
            break;
        end
    end
    
    % Обрезание градиента (gradient clipping)
    if options.gradient_clip > 0
        grad_norm_clip = norm(gradient);
        if grad_norm_clip > options.gradient_clip
            gradient = gradient * options.gradient_clip / grad_norm_clip;
        end
    end
    
    % Обновление скорости с моментом
    velocity = options.momentum * velocity - options.learning_rate * gradient;
    
    % Поиск по линии (опционально)
    if options.use_line_search
        alpha = lineSearch(SYSTEM, params, gradient, current_value, options.learning_rate);
        new_params = params + alpha * velocity;
    else
        new_params = params + velocity;
    end
    
    % Условия на параметры (ограничения)
    for p = 1:numel(params)
        if abs(new_params(p)) < 1
            params(p) = new_params(p);
        end
    end
    
    % Уменьшение скорости обучения
    if mod(iter, options.decay_step) == 0
        options.learning_rate = options.learning_rate * options.decay_rate;
    end
end

optimal_params = best_params;

if options.verbose
    fprintf('Оптимизация завершена.\n');
    fprintf('Лучшее значение функции: %.6e\n', best_value);
    fprintf('Всего итераций: %d\n', length(history.f_values));
end
end