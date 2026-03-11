clear all;
close all;


SiData = readtable('si.csv');
Si3N4Data = readtable('si3n4.csv');

Si_n = @(x) interp1(SiData.Var1, SiData.Var2, x, 'pchip', 0) + ...
    1j * interp1(SiData.Var1, SiData.Var3, x, 'pchip', 0);

Si3N4_n = @(x) interp1(Si3N4Data.Var1, Si3N4Data.Var2, x, 'pchip', 0) + ...
    1j * interp1(Si3N4Data.Var1, Si3N4Data.Var3, x, 'pchip', 0);

height = 0.22; %um
width = 0.5; %um
lmbd = 1.55; %um

k0 = 2*pi/lmbd;
q = k0 * height;

n_Si = 3.48;
n_SiO2 = 1.44;
n_Ge = 4;
n_Si3N4 = 2;

nc = 1.44;
ns = 1;
nf = n_Si3N4;

%% PLOT EQUATION (для TM моды)
n = linspace(max(nc, ns)+0.001, nf-0.001, 500);
lhs = q * sqrt(nf^2 - n.^2);

% Для TM моды
gamma_c = (nf/nc)^2;
gamma_s = (nf/ns)^2;

% Для TE моды
gamma_c = 1;
gamma_s = 1;

rhs = atan(gamma_c * sqrt((n.^2 - nc^2) ./ (nf^2 - n.^2))) + ...
    atan(gamma_s * sqrt((n.^2 - ns^2) ./ (nf^2 - n.^2)));

figure;
plot(n, lhs, 'DisplayName', 'Left-hand side', 'Color', 'black', 'LineWidth', 1.5);
M = 2; % Показываем первые 3 моды (m=0,1,2)
for m = 0:M
    hold on
    plot(n, rhs + pi*m, 'DisplayName', sprintf('Right-hand side for m = %d', m), 'LineWidth', 1.5);
end
title('Graphical solution for transcendental equation (TM mode)')
xlim([max(nc, ns), nf]);
xlabel('Effective refractive index')
ylabel('Value of equations sides')
legend('Location', 'best');
grid on;

% Находим эффективный показатель для TM моды
neff1 = getEffInd(ns, nf, nc, height, lmbd, "TE");
x = neff1;
y = q * sqrt(nf^2 - x.^2);

% Добавляем точку пересечения на график
hold on
plot(x, y, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'red');

% Добавляем аннотацию
ax = gca;
axPos = get(ax, 'Position');
xlims = get(ax, 'XLim');
ylims = get(ax, 'YLim');
x_norm_ax = (x - xlims(1)) / (xlims(2) - xlims(1));
y_norm_ax = (y - ylims(1)) / (ylims(2) - ylims(1));
x_norm_fig = axPos(1) + x_norm_ax * axPos(3);
y_norm_fig = axPos(2) + y_norm_ax * axPos(4);
annotation('textarrow', [x_norm_fig-0.1, x_norm_fig-0.01], ...
    [y_norm_fig+0.1, y_norm_fig+0.01], ...
    'String', sprintf('n_{eff} = %.4f', x), ...
    'FontSize', 10, ...
    'HeadWidth', 8, ...
    'HeadLength', 8);
% return

%% Второй этап EIM (горизонтальный анализ)
% Используем neff1 как показатель преломления сердечника для горизонтального анализа
% Ширина waveguidea становится толщиной для горизонтального слаб-волновода
neff2 = getEffInd(1, neff1, 1, width, lmbd, "TE");

%% Расчет поля TE моды
k0 = 2*pi/lmbd;
% Для горизонтального направления
kappa_c = k0 * sqrt(neff2^2 - n_SiO2^2);  % затухание в оболочке
kf = k0 * sqrt(neff1^2 - neff2^2);        % постоянная распространения в сердечнике
C = cos(kf * width / 2);  % коэффициент для непрерывности

figure;
x = linspace(-width*1.5, width*1.5, 500);
inner = abs(x) <= width / 2;
left = x < -width/2;
right = x > width/2;

% TE мода - основная компонента Ey
Ey = zeros(size(x));
Ey(inner) = cos(kf * x(inner));
Ey(left) = C * exp(kappa_c * (x(left) + width/2));
Ey(right) = C * exp(-kappa_c * (x(right) - width/2));

plot(x, abs(Ey).^2, 'LineWidth', 2);
hold on;
xline(-width/2, '--k', 'LineWidth', 1);
xline(width/2, '--k', 'LineWidth', 1);
xlabel('x (μm)');
ylabel('|E_y|^2');
title('TE_{00} Mode Profile (horizontal direction)');
grid on;

% Добавляем подписи
text(-width/2, max(abs(Ey).^2)*0.9, 'SiO_2', 'HorizontalAlignment', 'right');
text(0, max(abs(Ey).^2)*0.9, 'Si (core)', 'HorizontalAlignment', 'center');
text(width/2, max(abs(Ey).^2)*0.9, 'SiO_2', 'HorizontalAlignment', 'left');

fprintf('Результаты для TE моды:\n');
fprintf('  neff1 (вертикальный анализ) = %.4f\n', neff1);
fprintf('  neff2 (горизонтальный анализ) = %.4f\n', neff2);

%% АППРОКСИМАЦИЯ ГАУССОМ

%% Аппроксимация профиля гауссовой функцией
% Берем горизонтальный профиль из предыдущего расчета
x_profile = x;
Ey_profile = abs(Ey).^2;
Ey_profile = Ey_profile / max(Ey_profile); % Нормируем

% Определяем функцию Гаусса
gauss_func = @(p, x) p(1)*exp(-((x - p(2))/p(3)).^2) + p(4);

% Начальные параметры для подгонки
p0 = [1, 0, width/2, 0]; % [амплитуда, центр, ширина, смещение]

% Выполняем нелинейную аппроксимацию методом наименьших квадратов
options = optimset('Display','off');
p_fit = lsqcurvefit(gauss_func, p0, x_profile, Ey_profile, [], [], options);

% Вычисляем гауссову аппроксимацию
Ey_gauss = gauss_func(p_fit, x_profile);

% Вычисляем ширину моды на уровне 1/e^2
mode_width = abs(p_fit(3)) * 2; % ширина на уровне 1/e

% R^2 коэффициент детерминации
SS_res = sum((Ey_profile - Ey_gauss).^2);
SS_tot = sum((Ey_profile - mean(Ey_profile)).^2);
R2 = 1 - SS_res/SS_tot;

% Отрисовываем профиль и гауссову аппроксимацию
figure;
plot(x_profile, Ey_profile, 'b-', 'LineWidth', 2, 'DisplayName', 'Реальный профиль');
hold on;
plot(x_profile, Ey_gauss, 'r--', 'LineWidth', 2, 'DisplayName', sprintf('Гауссова аппроксимация (R^2=%.4f)', R2));
xline(-mode_width/2, 'k:', 'LineWidth', 1, 'DisplayName', sprintf('Ширина моды: %.3f μm', mode_width));
xline(mode_width/2, 'k:', 'LineWidth', 1, 'HandleVisibility', 'off');
xline(-width/2, 'k--', 'LineWidth', 1, 'DisplayName', 'Границы волновода');
xline(width/2, 'k--', 'LineWidth', 1, 'HandleVisibility', 'off');

xlabel('x (μm)');
ylabel('Нормированная интенсивность');
title('Аппроксимация профиля моды гауссовой функцией');
legend('Location', 'best');
grid on;

% Вывод результатов
fprintf('\n=== Результаты гауссовой аппроксимации ===\n');
fprintf('Параметры гауссовой функции:\n');
fprintf('  Амплитуда: %.4f\n', p_fit(1));
fprintf('  Центр: %.4f μm\n', p_fit(2));
fprintf('  Ширина (σ): %.4f μm\n', abs(p_fit(3)));
fprintf('  Смещение: %.4f\n', p_fit(4));
fprintf('Ширина моды на уровне 1/e^2: %.4f μm\n', mode_width);
fprintf('Коэффициент детерминации R^2: %.4f\n', R2);
fprintf('Ширина волновода: %.4f μm\n', width);
fprintf('Отношение ширины моды к ширине волновода: %.4f\n', mode_width/width);

% Добавляем кривые на предыдущий график профиля (фигура 3)
figure(3); % Предполагая, что график горизонтального профиля был figure(3)
hold on;
plot(x_profile, Ey_gauss, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Гауссова аппроксимация');
legend('show');

%% Расчет двумерного профиля интенсивности моды
% Создаем сетку для расчетов
x_points = 300;
z_points = 200;

% Координаты
x = linspace(-width*1.5, width*1.5, x_points);
z = linspace(-height*1.5, height*1.5, z_points);
[X, Z] = meshgrid(x, z);

% Определяем области: сердцевина и оболочка
core_region = (abs(X) <= width/2) & (abs(Z) <= height/2);
cladding_region = ~core_region;

% Для TE моды основная компонента Ey
% Вертикальная зависимость (аналогичная горизонтальной, но со своими параметрами)
kappa_c_vert = k0 * sqrt(neff1^2 - n_SiO2^2); % затухание в оболочке по вертикали
kf_vert = k0 * sqrt(n_Si^2 - neff1^2);       % постоянная в сердечнике по вертикали
C_vert = cos(kf_vert * height / 2);          % коэффициент для непрерывности

% Горизонтальная зависимость (уже рассчитана ранее)
kappa_c_horiz = k0 * sqrt(neff2^2 - n_SiO2^2); % затухание в оболочке по горизонтали
kf_horiz = k0 * sqrt(neff1^2 - neff2^2);       % постоянная в сердечнике по горизонтали
C_horiz = cos(kf_horiz * width / 2);           % коэффициент для непрерывности

% Инициализируем поле Ey
Ey_2D = zeros(size(X));

% Вычисляем поле в каждой точке
for i = 1:size(X,1)
    for j = 1:size(X,2)
        x_val = X(i,j);
        z_val = Z(i,j);
        
        % Горизонтальная зависимость
        if abs(x_val) <= width/2
            Ey_horiz = cos(kf_horiz * x_val);
        elseif x_val < -width/2
            Ey_horiz = C_horiz * exp(kappa_c_horiz * (x_val + width/2));
        else
            Ey_horiz = C_horiz * exp(-kappa_c_horiz * (x_val - width/2));
        end
        
        % Вертикальная зависимость
        if abs(z_val) <= height/2
            Ey_vert = cos(kf_vert * z_val);
        elseif z_val < -height/2
            Ey_vert = C_vert * exp(kappa_c_vert * (z_val + height/2));
        else
            Ey_vert = C_vert * exp(-kappa_c_vert * (z_val - height/2));
        end
        
        % Приближение EIM: полное поле = произведение горизонтальной и вертикальной зависимостей
        Ey_2D(i,j) = Ey_horiz * Ey_vert;
    end
end

% Интенсивность = |Ey|^2
Intensity = abs(Ey_2D).^2;

% Нормируем интенсивность на максимум
Intensity = Intensity / max(Intensity(:));

%% Отрисовка двумерного профиля
figure('Position', [100, 100, 1200, 500]);

% 1. 2D профиль интенсивности
subplot(1, 1,1);
imagesc(x, z, Intensity);
colormap('hot');
colorbar;
hold on;

% Контур волновода
rectangle('Position', [-width/2, -height/2, width, height], ...
    'EdgeColor', 'cyan', 'LineWidth', 2, 'LineStyle', '--');

axis equal;
axis tight;
xlabel('x (μm)');
ylabel('z (μm)');
title(sprintf('TE_{00} Mode Intensity Profile\nn_{eff} = %.4f', neff2));
set(gca, 'YDir', 'normal');

% Подписи
text(0, height/8*1.1, 'Si core', 'Color', 'black', ...
    'HorizontalAlignment', 'center', 'FontWeight', 'bold');
text(-width/2-width*0.2, 0, 'SiO_2', 'Color', 'white', ...
    'HorizontalAlignment', 'center', 'FontWeight', 'bold');


%% Функция для TE/TM моды
function n = getEffInd(ns, nf, nc, h, lmbd, type)
k0 = 2*pi/lmbd;
q = k0 * h;

if type == "TM"
    gamma_c = (nf/nc)^2;
    gamma_s = (nf/ns)^2;
else
    gamma_c = 1;
    gamma_s = 1;
end

% Уравнение для TM мод
func = @(x) q * sqrt(nf^2 - x.^2) - ...
    atan(gamma_c * sqrt((x.^2 - nc^2) ./ (nf^2 - x.^2))) - ...
    atan(gamma_s * sqrt((x.^2 - ns^2) ./ (nf^2 - x.^2)));

% Находим решение для фундаментальной моды (m=0)
% Используем опции fzero для избежания проблем на границах
options = optimset('Display', 'off', 'TolX', 1e-10);
n = fzero(func, [max(nc, ns)+0.01, nf-0.01], options);
end