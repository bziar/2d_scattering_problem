function obj = Calculate3(obj)
    M = obj.maxHarmNum;
    N = obj.numParticles;
    blockSize = 2 * M + 1;
    mArr = (-M:M).';
    
    calcDer = true;
    
    % Предвычисление матриц поворота
    rotationMatrices = cell(1, N);
    for k1 = 1:N
        rotationMatrices{k1} = diag(exp(1j * mArr * obj.angles{k1}));
    end
    
    % Создание meshgrid для разностей один раз
    [M_mesh, N_mesh] = meshgrid(mArr, mArr);
    diff_mn = M_mesh - N_mesh;
    
    %% Инициализация матриц
    transMatrices = cell(N, N);
    [transMatrices{:,:}] = deal(zeros(blockSize, blockSize));
    
    if calcDer
        B_der = zeros(blockSize, blockSize * N);
        H_der = zeros(blockSize * N, blockSize * N);
        J_der = zeros(blockSize * N, blockSize);
        trans_matr_der = cell(N, N);
        [trans_matr_der{:,:}] = deal(zeros(blockSize, blockSize));
    end
    
    %% Основные вычисления
    % Вычисление диагональных элементов transMatrices
    for k1 = 1:N
        % Применение вращения
        obj.scaMatrices{k1} = rotationMatrices{k1} * obj.scaMatrices{k1} * rotationMatrices{k1}';
        
        % Вычисление transMatrices для k1,k1
        [phi, d] = cart2pol(obj.coordinates{k1}(1), obj.coordinates{k1}(2));
        d = obj.refrIndexOut * d;
        
        transMatrices{k1, k1} = besselj(diff_mn, d) .* exp(-1j * diff_mn * phi);
    end
    
    % Вычисление недиагональных элементов transMatrices
    for k1 = 1:N
        for k2 = (k1+1):N
            [phi, d] = cart2pol(obj.coordinates{k1}(1) - obj.coordinates{k2}(1), ...
                obj.coordinates{k1}(2) - obj.coordinates{k2}(2));
            d = obj.refrIndexOut * d;
            
            transMatrices{k1, k2} = besselh(diff_mn, d) .* exp(-1j * diff_mn * phi);
            transMatrices{k2, k1} = transMatrices{k1, k2} .* exp(-1j * diff_mn * pi);
        end
    end
    
    %% Формирование глобальных матриц
    R = diag(exp(-1j * mArr * pi));
    
    % Предварительное выделение памяти для разреженных матриц
    totalSize = blockSize * N;
    J = zeros(totalSize, blockSize);
    B = zeros(blockSize, totalSize);
    
    if totalSize < 5000
        H = zeros(totalSize, totalSize);
    else
        H = sparse(totalSize, totalSize);
    end
    
    % Заполнение матриц блоками
    for k = 1:N
        idx = (k-1)*blockSize + (1:blockSize);
        J(idx, :) = transMatrices{k, k};
        B(:, idx) = R * transMatrices{k, k} * R.' * obj.scaMatrices{k};
        
        if totalSize < 5000
            H(idx, idx) = eye(blockSize);
        else
            H(idx, idx) = speye(blockSize);
        end
    end
    
    % Заполнение недиагональных блоков H
    for k1 = 1:N
        rows = (k1-1)*blockSize + (1:blockSize);
        for k2 = 1:N
            if k1 ~= k2
                cols = (k2-1)*blockSize + (1:blockSize);
                H_block = -transMatrices{k1, k2} * obj.scaMatrices{k2};
                
                if totalSize < 5000
                    H(rows, cols) = H_block;
                else
                    H(rows, cols) = sparse(H_block);
                end
            end
        end
    end
    
    %% Решение системы
    b = J * obj.incCoeffs;
    
    % Автоматический выбор метода решения
    if totalSize < 1000
        % Прямой метод для малых задач
        right = H \ b;
    else
        % Итерационный метод для больших задач
        [right, flag] = bicgstab(H, b, 1e-3, min(5000, totalSize*2));
        if flag ~= 0
            % Если bicgstab не сошелся, пробуем lsqr
            [right, flag] = lsqr(H, b, 1e-6, 2000);
        end
    end
    
    obj.scaCoeffs = B * right;

    a = obj.scaCoeffs;
    nrm = (a' * a);
    q = ((a' * obj.Q * a) / nrm);
    obj.targetFunc = q;
    
    
    %% Вычисление производных
    if calcDer
        %adjoint method
        dqdEs = ((a' * obj.Q - q * a') / nrm);
        b2 = B.' * dqdEs.';
        % Автоматический выбор метода решения
        if totalSize < 1000
            % Прямой метод для малых задач
            lmbd = H.' \ b2;
        else
            % Итерационный метод для больших задач
            [lmbd, flag] = bicgstab(H.', b2, 1e-3, min(5000, totalSize*2));
            if flag ~= 0
                % Если bicgstab не сошелся, пробуем lsqr
                [lmbd, flag] = lsqr(H.', b2, 1e-6, 2000);
            end
        end

        kArr = 1:N;
        
        %% Производные по радиусам
        for k = 1:N
            % Локальные матрицы производных
            temp_J_der = zeros(totalSize, blockSize);
            temp_H_der = zeros(totalSize, totalSize);
            temp_B_der = zeros(blockSize, totalSize);
            
            idx = (k-1)*blockSize + (1:blockSize);
            temp_B_der(:, idx) = R * transMatrices{k, k} * R.' * obj.scaMatrices_der{k};
            
            for k1 = 1:N
                if k1 ~= k
                    rows = (k1-1)*blockSize + (1:blockSize);
                    cols = (k-1)*blockSize + (1:blockSize);
                    temp_H_der(rows, cols) = -transMatrices{k1, k} * obj.scaMatrices_der{k};
                end
            end
            
            % [c, flag] = bicgstab(H, temp_H_der * right, 1e-3, 2000);
            obj.scaMatrix_der{k} = dqdEs * temp_B_der * right - lmbd.' * temp_H_der * right;
        end
        
        %% Производные по x и y
        for dim = 1:2  % 1 для x, 2 для y
            for k = 2:N
                % Вычисление производных трансляционных матриц
                trans_der = computeTranslationDerivatives(obj, k, mArr, M, N, dim);
                
                % Формирование производных матриц
                [temp_J_der, temp_B_der, temp_H_der] = ...
                    buildDerivativeMatrices(trans_der, obj.scaMatrices, R, blockSize, N, k);
                
                % Решение системы
                % rhs = temp_H_der * right - temp_J_der * obj.incCoeffs;
                % [c, flag] = bicgstab(H, rhs, 1e-3, 2000);
                
                % Сохранение результата
                idx = N + 2*k - 2 + dim;
                obj.scaMatrix_der{idx} = dqdEs * temp_B_der * right + lmbd.' * (temp_J_der * obj.incCoeffs - temp_H_der * right);
            end
        end
    end
end

function trans_der = computeTranslationDerivatives(obj, k, mArr, M, N, dim)
    blockSize = 2*M + 1;
    trans_der = cell(N, N);
    [trans_der{:,:}] = deal(zeros(blockSize, blockSize));
    
    % Предвычисление meshgrid
    [M_mesh, N_mesh] = meshgrid(mArr, mArr);
    diff_mn = M_mesh - N_mesh;
    
    % Производная для диагонального элемента
    x = obj.coordinates{k}(1);
    y = obj.coordinates{k}(2);
    d_val = sqrt(x^2 + y^2);
    phi = atan2(y, x);
    
    if d_val > 1e-12
        if dim == 1  % x
            d_xy = x / d_val;
            phi_xy = -y / d_val^2;
        else  % y
            d_xy = y / d_val;
            phi_xy = x / d_val^2;
        end
        
        d = obj.refrIndexOut * d_val;
        
        % Векторизованное вычисление для диагонального элемента
        trans_der{k, k} = (0.5 * obj.refrIndexOut * ...
            (besselj(diff_mn-1, d) - besselj(diff_mn+1, d)) * d_xy - ...
            1j * diff_mn .* besselj(diff_mn, d) .* phi_xy) .* ...
            exp(-1j * diff_mn * phi);
    end
    
    % Производные для недиагональных элементов
    kArr = 1:N;
    otherParticles = kArr(kArr ~= k);
    
    for k2 = otherParticles
        x1 = obj.coordinates{k}(1);
        y1 = obj.coordinates{k}(2);
        x2 = obj.coordinates{k2}(1);
        y2 = obj.coordinates{k2}(2);
        
        d_val = sqrt((x1 - x2)^2 + (y1 - y2)^2);
        phi = atan2((y1 - y2), (x1 - x2));
        
        if dim == 1  % x
            d_xy = (x1 - x2) / d_val;
            phi_xy = -(y1 - y2) / d_val^2;
        else  % y
            d_xy = (y1 - y2) / d_val;
            phi_xy = (x1 - x2) / d_val^2;
        end
        
        d = obj.refrIndexOut * d_val;
        
        % Векторизованное вычисление
        trans_der{k, k2} = (0.5 * obj.refrIndexOut * ...
            (besselh(diff_mn-1, d) - besselh(diff_mn+1, d)) * d_xy - ...
            1j * diff_mn .* besselh(diff_mn, d) .* phi_xy) .* ...
            exp(-1j * diff_mn * phi);
        
        trans_der{k2, k} = trans_der{k, k2} .* exp(-1j * diff_mn * pi);
    end
end

function [J_der, B_der, H_der] = buildDerivativeMatrices(trans_der, scaMatrices, R, blockSize, N, k)
    totalSize = blockSize * N;
    J_der = zeros(totalSize, blockSize);
    B_der = zeros(blockSize, totalSize);
    H_der = zeros(totalSize, totalSize);
    
    % Диагональные блоки
    idx = (k-1)*blockSize + (1:blockSize);
    J_der(idx, :) = trans_der{k, k};
    B_der(:, idx) = R * trans_der{k, k} * R.' * scaMatrices{k};
    
    % Недиагональные блоки H_der
    for k1 = 1:N
        if k1 ~= k
            rows = (k1-1)*blockSize + (1:blockSize);
            cols = (k-1)*blockSize + (1:blockSize);
            H_der(rows, cols) = -trans_der{k1, k} * scaMatrices{k};
            
            rows = (k-1)*blockSize + (1:blockSize);
            cols = (k1-1)*blockSize + (1:blockSize);
            H_der(rows, cols) = -trans_der{k, k1} * scaMatrices{k1};
        end
    end
end