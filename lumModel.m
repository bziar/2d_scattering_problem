
% generate_random_cylinders();

params = load('best_solution.mat');
N = (length(params.best_overall_params) + 2)/3;
r = 0.4;

radii = r * (1 + params.best_overall_params(1:N));
init = startPosition(N, 2.8*r);
c = params.best_overall_params(N+1:end);
coords = reshape(cell2mat(init) + r * [0; 0; c], [2, N]).';

lmbd = 1.6; %um
radii = radii * lmbd / 2 / pi;
coords = coords * lmbd / 2 / pi;
for i = 1:N
    coords(i, 2) = - coords(i, 2);
end

% create_varFDTD_cylinders(coords * 1e-6, radii * 1e-6, 'SiO2 (Glass) - Palik', 'Si (Silicon) - Palik');
create_varFDTD_cylinders(coords * 1e-6, radii * 1e-6, 'SiO2 (Glass) - Palik', 'Si3N4 (Silicon Nitride) - Phillip');


function create_varFDTD_cylinders(coords, radii, substrate_material, cylinder_material)
% CREATE_VARFDTD_CYLINDERS Создает 2D varFDTD симуляцию с цилиндрами на подложке
%   coords - массив Nx2 с координатами [x, y] центров цилиндров
%   radii - массив Nx1 с радиусами цилиндров
%   substrate_material - имя материала подложки (например, 'SiO2 (Glass) - Palik')
%   cylinder_material - имя материала цилиндров (например, 'Si (Silicon) - Palik')

%% Проверка входных данных
if nargin < 4
    error('Необходимо указать все входные параметры');
end

if size(coords, 1) ~= length(radii)
    error('Количество координат должно соответствовать количеству радиусов');
end

addpath('C:\Program Files\Lumerical\v202\api\matlab');

%% Подключение к Lumerical
try
    % Попытка подключиться к существующему сеансу
    h = appopen('matlab');
    if isempty(h)
        % Если нет активного сеанса, создаем новый
        h = appopen('mode');
    end
catch
    % Если ошибка подключения, создаем новый сеанс
    h = appopen('mode');
end

%% Создание новой симуляции
% Очищаем текущую симуляцию
appevalscript(h, 'deleteall;');

% appevalscript(h, 'set("name", "varFDTD_simulation");');

%% Настройка размеров симуляции
% Определяем границы области на основе координат цилиндров
x_coords = coords(:, 1);
y_coords = coords(:, 2);

test_points = coords; % [x, y] координаты центров цилиндров

rmax = max(radii);
rho_max =  max(sqrt(coords(:, 1).^2 + coords(:, 2).^2));
area_radius = (rho_max + rmax) * 3.5;

input_width = 1.5e-6;
input_length = 8e-6;
length2 = 4e-6;

l = area_radius + input_length * (1/2 - 1/8);
l2 = area_radius + length2 * (1/2 - 1/8);

x_min = -2.9 * area_radius/2;
x_max = 2.9 * area_radius/2;
y_min = -2.9 * area_radius/2;
y_max = 2.9 * area_radius/2;

rot45 = [sqrt(2)/2, -sqrt(2)/2;
    sqrt(2)/2, sqrt(2)/2];
xshift = l2;
yshift = l2;

a = [xshift, yshift] + (rot45 * [-length2/2; input_width/2]).';
b = [xshift, yshift] + (rot45 * [length2/2; input_width/2]).';
c = [xshift, yshift] + (rot45 * [length2/2; -input_width/2]).';
d = [xshift, yshift] + (rot45 * [-length2/2; -input_width/2]).';
A = d;
out1 = [a; b; c; d];
a(2) = -a(2);
b(2) = -b(2);
c(2) = -c(2);
d(2) = -d(2);
out2 = [a; b; c; d];
C = d;
B = [A(1) - (A(2)*sqrt(2) - A(2)), 0];

arc_points = get_arc_points(A*1e6, B*1e6, C*1e6, 40)*1e-6;
l1 = -l+input_length/2;
kr = 0.35;
areaPoints = [l1, -input_width/2;
    kr * l1, -input_width/2;
    kr * l1, -kr * l1;
    out1; arc_points; flip(out2);
    kr * l1, kr * l1;
    kr * l1, input_width/2;
    l1, input_width/2];

% Рисуем
% figure;
% hold on;
% plot(areaPoints(:,1), areaPoints(:,2));
% axis equal




%% Создание подложки
appevalscript(h, 'addrect;');
appevalscript(h, 'set("name", "substrate");');
appevalscript(h, sprintf('set("material", "%s");', substrate_material));



% Размеры подложки (немного больше области симуляции)
appevalscript(h, sprintf('set("x span", %e);', 3*area_radius));
appevalscript(h, sprintf('set("y span", %e);', 3*area_radius));
appevalscript(h, 'set("z span", 2e-6);'); % Толщина подложки
appevalscript(h, 'set("z", 0e-6);'); % Положение по Z (центр подложки)
appevalscript(h, 'set("alpha", 0.5);');
appevalscript(h, 'set("override mesh order from material database", 1);');
appevalscript(h, 'set("mesh order", 3);');

%% Создание цилиндров (как кругов в 2D)
% appevalscript(h, 'addcircle;');
% appevalscript(h, sprintf('set("name", "cylinder_0");'));
% appevalscript(h, sprintf('set("material", "%s");', cylinder_material));
% appevalscript(h, 'set("alpha", 0.8);');
% appevalscript(h, sprintf('set("x", %e);', 0));
% appevalscript(h, sprintf('set("y", %e);', 0));
% appevalscript(h, sprintf('set("radius", %e);', area_radius));
% appevalscript(h, 'set("z span", 0.4e-6);');
% appevalscript(h, 'set("z", 0.2e-6);');
% appevalscript(h, 'set("override mesh order from material database", 1);');
% appevalscript(h, 'set("mesh order", 2);');

% appevalscript(h, 'addpoly;');
% appevalscript(h, sprintf('set("name", "area0");'));
% appevalscript(h, sprintf('set("material", "%s");', cylinder_material));
% appevalscript(h, 'set("alpha", 0.8);');
% appevalscript(h, sprintf('set("x", %e);', 0));
% appevalscript(h, sprintf('set("y", %e);', 0));

% appevalscript(h, 'set("z span", 0.4e-6);'); % Толщина
% appevalscript(h, 'set("z", 0.2e-6);'); % Положение по Z (центр подложки)
% appputvar(h, 'areacoords', areaPoints);
% appevalscript(h, 'set("vertices", areacoords);');



%% Создание входа
appevalscript(h, 'addrect;');
appevalscript(h, 'set("name", "input");');
appevalscript(h, sprintf('set("material", "%s");', cylinder_material));

% Размеры входа (немного больше области симуляции)
appevalscript(h, sprintf('set("x", %e);', -l/2));
appevalscript(h, sprintf('set("x span", %e);', input_length));
appevalscript(h, sprintf('set("y span", %e);', input_width));
appevalscript(h, 'set("z span", 0.4e-6);'); % Толщина
appevalscript(h, 'set("z", 0.2e-6);'); % Положение по Z (центр подложки)
% appevalscript(h, 'set("alpha", 0.5);');

appevalscript(h, 'addcircle;');
appevalscript(h, sprintf('set("name", "area0");'));

% Устанавливаем координаты центра
appevalscript(h, sprintf('set("x", %e);', 0));
appevalscript(h, sprintf('set("y", %e);', 0));
appevalscript(h, sprintf('set("radius", %e);', 1.5*max(coords(:))));
appevalscript(h, 'set("z span", 0.4e-6);');
appevalscript(h, 'set("z", 0.2e-6);');

appevalscript(h, 'set("override mesh order from material database", 1);');
appevalscript(h, 'set("mesh order", 1);');

appevalscript(h, sprintf('set("material", "%s");', substrate_material));
% appevalscript(h, 'set("material", "Ge (Germanium) - Palik");');
appevalscript(h, 'set("material", "Si3N4 (Silicon Nitride) - Phillip");');
% appevalscript(h, 'set("material", "Si (Silicon) - Palik");');


%% Создание выхода 1
appevalscript(h, 'addrect;');
appevalscript(h, 'set("name", "input1");');
appevalscript(h, sprintf('set("material", "%s");', cylinder_material));

% Размеры входа (немного больше области симуляции)
alpha = pi/6;
appevalscript(h, sprintf('set("x", %e);', l2 * cos(alpha)));
appevalscript(h, sprintf('set("y", %e);', l2 * sin(alpha)));
appevalscript(h, sprintf('set("x span", %e);', input_length*2));
appevalscript(h, sprintf('set("y span", %e);', input_width));
appevalscript(h, 'set("z span", 0.4e-6);'); % Толщина
appevalscript(h, 'set("z", 0.2e-6);'); % Положение по Z (центр подложки)
appevalscript(h, 'set("first axis", "z");');
appevalscript(h, sprintf('set("rotation 1", %d);', alpha * 180 / pi));
% appevalscript(h, 'set("alpha", 0.5);');

%% Создание выхода 2
alpha = pi/6;
appevalscript(h, 'addrect;');
appevalscript(h, 'set("name", "input2");');
appevalscript(h, sprintf('set("material", "%s");', cylinder_material));
appevalscript(h, sprintf('set("x", %e);',  l2 * cos(alpha)));
appevalscript(h, sprintf('set("y", %e);', - l2 * sin(alpha)));
appevalscript(h, sprintf('set("x span", %e);', input_length*2));
appevalscript(h, sprintf('set("y span", %e);', input_width));
appevalscript(h, 'set("z span", 0.4e-6);'); % Толщина
appevalscript(h, 'set("z", 0.2e-6);'); % Положение по Z (центр подложки)
appevalscript(h, 'set("first axis", "z");');
appevalscript(h, sprintf('set("rotation 1", -%d);', alpha * 180 / pi));

% appevalscript(h, 'addrect;');
% appevalscript(h, 'set("name", "input3");');
% appevalscript(h, sprintf('set("material", "%s");', cylinder_material));
% appevalscript(h, sprintf('set("x", %e);',  l2 * cos(alpha)));
% appevalscript(h, sprintf('set("y", %e);', 0));
% appevalscript(h, sprintf('set("x span", %e);', input_length*2));
% appevalscript(h, sprintf('set("y span", %e);', input_width));
% appevalscript(h, 'set("z span", 0.4e-6);'); % Толщина
% appevalscript(h, 'set("z", 0.2e-6);'); % Положение по Z (центр подложки)
% appevalscript(h, 'set("first axis", "z");');
% appevalscript(h, sprintf('set("rotation 1", -%d);', alpha * 180 / pi));
% appevalscript(h, 'set("alpha", 0.5);');
% appevalscript(h, 'set("alpha", 0.5);');



for i = 1:size(coords, 1)
    if (radii(i) > 0.02e-6)
        % Создаем круг (цилиндр в 2D сечении)
        appevalscript(h, 'addcircle;');
        appevalscript(h, sprintf('set("name", "cylinder_%d");', i));
        appevalscript(h, sprintf('set("index", "%e");', 1));
        
        % Устанавливаем координаты центра
        appevalscript(h, sprintf('set("x", %e);', coords(i, 1)));
        appevalscript(h, sprintf('set("y", %e);', coords(i, 2)));
        
        % Устанавливаем радиус
        appevalscript(h, sprintf('set("radius", %e);', radii(i)));
        
        % Для 2D varFDTD толщина в Z не важна, но можно установить
        appevalscript(h, 'set("z span", 0.4e-6);');
        appevalscript(h, 'set("z", 0.2e-6);');
        
        appevalscript(h, 'set("override mesh order from material database", 1);');
        appevalscript(h, 'set("mesh order", 1);');
        
        appevalscript(h, sprintf('set("material", "%s");', substrate_material));
        appevalscript(h, 'set("material", "Ge (Germanium) - Palik");');
        % appevalscript(h, 'set("material", "Si3N4 (Silicon Nitride) - Phillip");');
    end
end

%% modeSolver
% appevalscript(h, 'addeigenmode;');
% appevalscript(h, 'set("solver type", "2D X normal");');
% appevalscript(h, sprintf('set("x", %e);', -l));
% appevalscript(h, sprintf('set("y", %e);', 0));
% appevalscript(h, 'set("y span", 1e-6);');
% appevalscript(h, 'set("z span", 1e-6);');

% appevalscript('run;');
% appevalscript('findmodes()');
% appevalscript('switchtolayout');

% Создаем новую varFDTD симуляцию
appevalscript(h, 'addvarfdtd;');
appevalscript(h, sprintf('set("x span", %e);', 2.95 * area_radius));
appevalscript(h, sprintf('set("y span", %e);', 2.95 * area_radius));
appevalscript(h, 'set("z span", 2e-6);'); % Толщина в Z направлении для 2D
appevalscript(h, sprintf('set("x0", %e);', -0.95*l));
appevalscript(h, 'set("mesh accuracy", 3);');

% Можно добавить дополнительные test points по углам области
% для лучшей интерполяции
extra_points = [
    x_min, y_min;
    x_max, y_min;
    x_min, y_max;
    x_max, y_max;
    (x_min + x_max)/2, (y_min + y_max)/2;
    -l, 0;
    l2*sqrt(2)/2, l2*sqrt(2)/2;
    l2*sqrt(2)/2, -l2*sqrt(2)/2;
    ];

% Объединяем все test points
all_test_points = [test_points; extra_points];

% Устанавливаем количество test points
appevalscript(h, sprintf('set("number of test points", %d);', size(all_test_points, 1)));
appputvar(h, 'test_points_coords', all_test_points);
appevalscript(h, 'set("test points", test_points_coords);')

appevalscript(h, 'addmodesource;');
appevalscript(h, 'set("injection axis", "x-axis");');
appevalscript(h, sprintf('set("x", %e);', -0.95*l));
appevalscript(h, sprintf('set("y span", %e);', 6e-6));
appevalscript(h, 'set("mode selection", "fundamental mode");');
% appevalscript(h, 'set("mode selection", "user select");');
% appevalscript(h, 'set("selected mode number", 1);');
appevalscript(h, sprintf('set("wavelength start", %e);', (1.25)*1e-6));
appevalscript(h, sprintf('set("wavelength stop", %e);', (1.65)*1e-6));


appevalscript(h, 'addpower;');
appevalscript(h, 'set("name", "profile");');
appevalscript(h, sprintf('set("x span", %e);', 2.8 * area_radius));
appevalscript(h, sprintf('set("y span", %e);', 2.8 * area_radius));
appevalscript(h, 'set("z", 0.2e-6);');

appevalscript(h, 'addeffectiveindex;');
appevalscript(h, 'set("name", "effInd");');
appevalscript(h, sprintf('set("x span", %e);', 2.5 * area_radius));
appevalscript(h, sprintf('set("y span", %e);', 2.5 * area_radius));
appevalscript(h, 'set("z", 0.2e-6);');

appevalscript(h, 'addpower;');
appevalscript(h, 'set("name", "out1");');
appevalscript(h, 'set("monitor type", "2D X-normal");');
appevalscript(h, sprintf('set("x", %e);', l2 * sqrt(2)/2));
appevalscript(h, sprintf('set("y", %e);', l2 * sqrt(2)/2));
appevalscript(h, sprintf('set("y span", %e);', 4e-6 * sqrt(2)/2));
appevalscript(h, sprintf('set("z span", %e);', 0.75e-6));
appevalscript(h, 'set("z", 0.2e-6);');

appevalscript(h, 'addpower;');
appevalscript(h, 'set("name", "out2");');
appevalscript(h, 'set("monitor type", "2D X-normal");');
appevalscript(h, sprintf('set("x", %e);', l2 * sqrt(2)/2));
appevalscript(h, sprintf('set("y", %e);', -l2 * sqrt(2)/2));
appevalscript(h, sprintf('set("y span", %e);', 4e-6 * sqrt(2)/2));
appevalscript(h, sprintf('set("z span", %e);', 0.75e-6));
appevalscript(h, 'set("z", 0.2e-6);');
% appevalscript(h, 'setactivesolver("FDE");');


%% Сохранение проекта
% appevalscript(h, 'save("varFDTD_cylinders_project");');

%% Проверка структуры
% Визуализируем созданную структуру
% appevalscript(h, 'switchtolayout;');
% appevalscript(h, 'visualize;');

disp('Симуляция успешно создана!');
disp(['Создано цилиндров: ', num2str(size(coords, 1))]);

%% Опционально: запуск симуляции
% Раскомментируйте следующие строки для автоматического запуска
appevalscript(h, 'run;');
% disp('Симуляция запущена!');
end

% Пример использования:
% coords = [0, 0; 2e-6, 2e-6; -1e-6, 1e-6];
% radii = [0.5e-6; 0.3e-6; 0.4e-6];
% create_varFDTD_cylinders(coords, radii, 'SiO2 (Glass) - Palik', 'Si (Silicon) - Palik');












































