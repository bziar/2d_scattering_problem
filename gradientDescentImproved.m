%% Улучшенный градиентный спуск
function [optimal_params, history, SYSTEM] = gradientDescentImproved(SYSTEM, initial_params, options, targetFunction)
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
    'tolerance', 1e-9, ...
    'grad_tolerance', 1e-9, ...
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
   [current_value, gradient, SYSTEM] = targetFunction(SYSTEM, params);

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

% На всякий случай: гарантируем, что возвращаемые параметры соответствуют
% наименьшему значению функции из истории.
if ~isempty(history.f_values) && ~isempty(history.params_history)
    [best_value_hist, idx_best] = min(history.f_values);
    if best_value_hist < best_value && idx_best <= size(history.params_history, 2)
        best_value = best_value_hist;
        best_params = history.params_history(:, idx_best);
        optimal_params = best_params;
    end
end
end
