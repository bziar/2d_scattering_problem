function rel_error_central = check_gradient(fun, theta)
% CHECK_GRADIENT Проверка правильности расчета градиента
%   fun - функция, возвращающая [значение, градиент]
%   theta - вектор параметров для проверки
%   varargin - дополнительные аргументы для fun

% Получаем значение и аналитический градиент от функции
[f, grad] = fun(theta);
fprintf('Аналитический градиент:\n');
disp(grad);

% Параметры для численного дифференцирования
eps = 1e-9;  % шаг для конечных разностей
n = length(theta);
grad_num = zeros(n, 1);  % численный градиент

% Вычисляем численный градиент методом центральных разностей
for i = 1:n
    theta_plus = theta;
    theta_minus = theta;
    
    % Увеличиваем i-й параметр на eps
    theta_plus(i) = theta_plus(i) + eps;
    f_plus = fun(theta_plus);
    if iscell(f_plus)
        f_plus = f_plus{1};
    end
    
    % Уменьшаем i-й параметр на eps
    theta_minus(i) = theta_minus(i) - eps;
    f_minus = fun(theta_minus);
    if iscell(f_minus)
        f_minus = f_minus{1};
    end
    
    % Центральная разность
    grad_num(i) = (f_plus - f_minus) / (2 * eps);
end

fprintf('\nЧисленный градиент (центральные разности):\n');
disp(grad_num);

% Альтернативный вариант: метод forward difference
grad_num_fwd = zeros(n, 1);
for i = 1:n
    theta_plus = theta;
    theta_plus(i) = theta_plus(i) + eps;
    f_plus = fun(theta_plus);
    if iscell(f_plus)
        f_plus = f_plus{1};
    end
    
    % Прямая разность
    grad_num_fwd(i) = (f_plus - f) / eps;
end

fprintf('\nЧисленный градиент (прямые разности):\n');
disp(grad_num_fwd);

% Вычисляем относительные ошибки
rel_error_central = norm(grad - grad_num) / (norm(grad) + norm(grad_num) + eps);
rel_error_forward = norm(grad - grad_num_fwd) / (norm(grad) + norm(grad_num_fwd) + eps);

fprintf('\nОтносительная ошибка:\n');
fprintf('Центральные разности: %e\n', rel_error_central);
fprintf('Прямые разности:     %e\n', rel_error_forward);

% Проверяем по компонентам
fprintf('\nПроверка по компонентам:\n');
fprintf('№\tАналит.\t\tЧисл.(центр.)\tРазность\tОтн.ошибка\n');
for i = 1:n
    diff = abs(grad(i) - grad_num(i));
    rel = diff / (abs(grad(i)) + abs(grad_num(i)) + eps);
    fprintf('%d\t%10.6f\t%10.6f\t%10.6f\t%10.2e\n', ...
            i, grad(i), grad_num(i), diff, rel);
end

% Рекомендации
fprintf('\nРекомендации:\n');
if rel_error_central < 1e-7
    fprintf('✓ Градиент вычислен корректно (ошибка < 1e-7)\n');
elseif rel_error_central < 1e-5
    fprintf('✓ Градиент, вероятно, корректен (ошибка < 1e-5)\n');
elseif rel_error_central < 1e-3
    fprintf('⚠ Возможны небольшие ошибки (ошибка < 1e-3)\n');
else
    fprintf('✗ Возможны серьезные ошибки в вычислении градиента\n');
end
end