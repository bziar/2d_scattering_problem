function obj = SetShape(obj, type)
switch(type)
    case 'superellipse'
        a = 1; b = 0.9; n = 100; N_coeffs = 40; n_points = 2048;
        % Вычисление коэффициентов Фурье для суперэллипса (кривой Ламе)
        % (x/a)^n + (y/b)^n = 1
        %
        % Вход:
        %   a, b - полуоси
        %   n - степень суперэллипса
        %   N_coeffs - количество гармоник (коэффициентов a_k, b_k)
        %   n_points - число точек для численного интегрирования
        %
        % Выход:
        %   coeffs = [a1, b1, a2, b2, ..., aN, bN]
        
        if nargin < 5
            n_points = 2048;  % Точность вычислений
        end
        
        % 1. Создаем равномерную сетку по углу
        phi = linspace(0, 2*pi, n_points + 1);
        phi = phi(1:end-1);  % Убираем последнюю точку (2π = 0)
        
        % 2. Параметрическое представление суперэллипса
        % Для четного n: r(phi) = 1 / ((|cos(phi)/a|^n + |sin(phi)/b|^n)^(1/n))
        
        cos_phi = cos(phi);
        sin_phi = sin(phi);
        
        % Радиус в полярных координатах
        r = 1 ./ ( (abs(cos_phi/a).^n + abs(sin_phi/b).^n) .^ (1/n) );
        
        % 3. Вычитаем 1 (так как ваш ряд: 1 + a1*sin(phi) + b1*cos(phi) + ...)
        r_normalized = r - 1;
        
        % 4. Вычисляем коэффициенты Фурье
        coeffs = zeros(1, 2*N_coeffs);
        
        for k = 1:N_coeffs
            % Коэффициент a_k для sin(k*phi)
            integrand_sin = r_normalized .* sin(k*phi);
            a_k = trapz(phi, integrand_sin) / pi;
            
            % Коэффициент b_k для cos(k*phi)
            integrand_cos = r_normalized .* cos(k*phi);
            b_k = trapz(phi, integrand_cos) / pi;
            
            coeffs(2*k-1) = a_k;
            coeffs(2*k) = b_k;
        end
        ShapeUpdate(obj, coeffs);
end
end