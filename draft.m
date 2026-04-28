
s = struct();
% f = @(x) targetFunction(s, x);
N = 100;
init = randi(1, [1, N]);

disp(init)

options = struct();
options.method = 'adam';
options.learning_rate = 0.5;
options.max_iterations = 1000;
options.beta1 = 0.9;
options.beta2 = 0.999;
options.plateau_patience = 10;
options.noise_scale = 0.01;
options.gradient_clip = 1.0;
options.bounds = zeros(2, N);
for i = 1:N
    options.bounds(1, i) = -100;
    options.bounds(2, i) = 100;
end

options = optimset(PlotFcns=@optimplotfval);
x = fminsearch(@(x) targetFunction(s, x), init);

return
[optimal_params, history, s] = gradientDescentImproved(s, init, options, @targetFunction);

%% Анализ и визуализация результатов
fprintf('\n=== РЕЗУЛЬТАТЫ ОПТИМИЗАЦИИ ===\n');

% Визуализация истории сходимости для всех запусков
figure('Name', 'Сравнение запусков', 'Position', [100, 100, 1200, 800]);

% График значений функции
subplot(2, 2, 1);
hold on;

plot(history.f_values, ...
    'LineWidth', 0.2);

xlabel('Итерация');
ylabel('Значение функции');
title('Сходимость для разных запусков');
% legend('show', 'Location', 'best');
grid on;

% График норм градиента
subplot(2, 2, 2);
hold on;
    plot(history.grad_norms, ...
        'LineWidth', 0.2);
xlabel('Итерация');
ylabel('Норма градиента');
title('Норма градиента');
set(gca, 'YScale', 'log');
grid on;



function [current_value, gradient, SYSTEM] = targetFunction(SYSTEM, params)
    current_value = norm(params);
    gradient = zeros(size(params));
    for i = 1:numel(params)
        gradient(i) = params(i) / current_value;
    end
end