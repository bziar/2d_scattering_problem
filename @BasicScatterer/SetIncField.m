function obj = SetIncField(obj, type, coeffs)
switch lower(type)
    case 'planewave'
        mArr = (-obj.maxHarmNum:obj.maxHarmNum);
        % obj.incCoeffs = 0 * obj.incCoeffs;
        % alphaMax = pi/6;
        % for alpha = linspace(-alphaMax, alphaMax, 50)
        %     obj.incCoeffs = obj.incCoeffs + exp(1j * mArr.' * alpha);
        % end
        % obj.incCoeffs = obj.incCoeffs / max(obj.incCoeffs);
        obj.incCoeffs = (1j) .^ mArr.';


    case 'gauss'
        % ===== Complex source beam =====
        
        % Параметры пучка
        w0 = 8;
        L  = 0;
        h  = 0;
        
        n_medium = obj.refrIndexOut;
        k = n_medium;
        
        % Rayleigh length
        zR = k * w0^2 / 2;
        
        % Комплексный источник
        x_c = L + 1i * zR;
        y_c = h;
        
        % Радиус (комплексный)
        r_c = sqrt(x_c^2 + y_c^2);
        
        % Фаза без atan2 (устойчиво)
        phaseFactor = (x_c - 1i * y_c) / r_c;
        
        % Гармоники
        mArr = (-obj.maxHarmNum:obj.maxHarmNum);
        obj.incCoeffs = zeros(length(mArr),1);
        
        for m = mArr
            mInd = m + obj.maxHarmNum + 1;
            
            obj.incCoeffs(mInd) = ...
                besselj(m, k * r_c) * phaseFactor^m;
        end
        
        % (опционально) нормировка
        obj.incCoeffs = obj.incCoeffs / max(abs(obj.incCoeffs));


    case 'other'
        obj.incCoeffs = coeffs;
end

obj.scaCoeffs = obj.scaMatrix * obj.incCoeffs;
obj.intCoeffs = obj.intMatrix * obj.incCoeffs;

% Вложенная функция с учетом среды
    function E = gaussianBeam(r, z, w0, n)
        % r - радиальная координата
        % z - продольная координата (от перетяжки)
        % w0 - радиус перетяжки на уровне 1/e от амплитуды
        % n - показатель преломления среды
        
        % Длина Рэлея в среде
        zR = w0^2 * n / 2;
        
        % Ширина пучка на расстоянии z
        w_z = w0 * sqrt(1 + (z / zR).^2);
        
        % Радиус кривизны волнового фронта
        R_z = z .* (1 + (zR ./ z).^2);
        % Устраняем деление на ноль при z=0
        R_z(z == 0) = Inf;
        
        % Гуйовский сдвиг фазы
        phi_G = atan(z / zR);
        
        % Комплексный параметр q(z)
        q_z = z + 1j * zR;
        
        % Амплитудный множитель
        A = w0 ./ w_z;
        
        % Поле гауссова пучка (нормированное)
        E = A .* exp(-(r ./ w_z).^2) .* ...
            exp(-1j * (n * z + n * r.^2 ./ (2 * R_z) - phi_G));
        
        % Альтернативная запись через q-параметр:
        
    end

end