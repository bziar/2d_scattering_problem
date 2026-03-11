function obj = Calculate(obj)

M = obj.maxHarmNum;
N = obj.numParticles;
blockSize = 2*M+1;
mArr = (-M:M);

retransMatrices = obj.transMatrices;
for k = 1:N
    rotationMat = diag(exp(1j * mArr * obj.angles{k}));
    obj.scaMatrices{k} = rotationMat * obj.scaMatrices{k} * rotationMat';
    [phi, d] = cart2pol(obj.coordinates{k}(1), obj.coordinates{k}(2));
    for m = mArr
        n = mArr;
        mInd = m + M + 1;
        obj.transMatrices{k, k}(mInd, :) = besselj(m-n, d) .* exp(1j * (m-n) * phi);
        retransMatrices{k, k}(mInd, :) = besselj(m-n, d) .* exp(-1j * (m-n) * phi);
    end
end

for k1 = 1:N
    for k2 = (k1+1):N
        [phi, d] = cart2pol(obj.coordinates{k1}(1) - obj.coordinates{k2}(1), ...
            obj.coordinates{k1}(2) - obj.coordinates{k2}(2));
        for m = mArr
            n = mArr;
            mInd = m + M + 1;
            obj.transMatrices{k1, k2}(mInd, :) = besselh(m-n, d) .* exp(1j * (m-n) * phi);
            obj.transMatrices{k2, k1}(mInd, :) = besselh(m-n, d) .* exp(-1j * (m-n) * phi);
        end
    end
end

% P = diag((-1).^mArr);

% for k1 = 1:N
%     for k2 = k1+1:N
%         obj.transMatrices{k2, k1} = P * (obj.transMatrices{k1, k2})' * P;
%     end
% end

J = zeros(blockSize * N, blockSize);
B = zeros(blockSize, blockSize * N);
H = zeros(blockSize * N, blockSize * N);

for k = 1:N
    startRow = (k-1)*blockSize + 1;
    endRow = k*blockSize;
    J(startRow:endRow, :) = obj.transMatrices{k, k};
    B(:, startRow:endRow) = retransMatrices{k, k} * obj.scaMatrices{k};
end

for k1 = 1:N
    for k2 = 1:N
        startRow1 = (k1-1)*blockSize + 1;
        endRow1 = k1*blockSize;
        startRow2 = (k2-1)*blockSize + 1;
        endRow2 = k2*blockSize;
        if (k1 == k2)
            H(startRow1:endRow1, startRow2:endRow2) = eye(blockSize);
        else
            H(startRow1:endRow1, startRow2:endRow2) = -obj.transMatrices{k1, k2} * obj.scaMatrices{k2};
        end
    end
end

% result = B * pinv(H, 1e-6) * J;
result = B * (H \ J);
% result = B * solve_bicgstab_simple(H, J, 1e-12, 500);
% result = compute_scattering_matrix(B, H, J, 'tol', 1e-10, 'maxit', 500);

obj.scaMatrix = result;

% rotationMat = diag(exp(1j * mArr * pi/2));
% obj.scaMatrix = rotationMat * obj.scaMatrix * rotationMat';


obj.scaCoeffs = obj.scaMatrix * obj.incCoeffs;

    function X = solve_bicgstab_simple(H, J, tol, maxit)
        % Упрощенная версия, которая работает с любыми матрицами
        
        [M, K] = size(J);
        X = zeros(M, K);
        
        % Если матрица большая и плотная, преобразуем в разреженную (если это имеет смысл)
        if ~issparse(H) && M > 500
            density = nnz(H) / numel(H);
            if density < 0.1  % Если разреженность менее 10%
                H = sparse(H);
                fprintf('Матрица преобразована в разреженную (заполнение: %.1f%%)\n', density*100);
            end
        end
        
        % Простой диагональный предобуславливатель (работает всегда)
        D = diag(H);
        if any(D == 0)
            warning('Обнаружены нули на диагонали. Добавляем epsilon.');
            D = D + eps * max(abs(D));
        end
        M_precond = spdiags(1./D, 0, M, M);
        
        % Решение
        for k = 1:K
            [X(:,k), flag] = bicgstab(H, J(:,k), tol, maxit, M_precond);
            
            if flag ~= 0
                % Пробуем без предобуславливателя
                [X(:,k), flag] = bicgstab(H, J(:,k), tol, maxit);
                
                if flag ~= 0
                    warning('BICGSTAB не сошелся для столбца %d (flag=%d). Использую псевдообращение.', k, flag);
                    % Используем псевдообращение как запасной вариант
                    X(:,k) = pinv(H) * J(:,k);
                end
            end
        end
    end

    function S = compute_scattering_matrix(B, H, J, varargin)
        % Вычисление матрицы рассеяния S = B * inv(H) * J с использованием BiCG
        % Входные параметры:
        %   B - матрица размером [M, M*N]
        %   H - матрица размером [M*N, M*N]
        %   J - матрица размером [M*N, M]
        %   varargin - опциональные параметры:
        %       'tol' - допуск сходимости (по умолчанию 1e-10)
        %       'maxit' - максимальное число итераций (по умолчанию min(size(H,1), 200))
        %       'preconditioner' - тип предобусловливания: 'none', 'diag', 'ilu' (по умолчанию 'ilu')
        %       'verbose' - вывод информации о сходимости (по умолчанию true)
        
        % Параметры по умолчанию
        tol = 1e-10;
        maxit = min(size(H,1), 200);
        preconditioner_type = 'ilu';
        verbose = true;
        
        % Обработка опциональных параметров
        for i = 1:2:length(varargin)
            switch lower(varargin{i})
                case 'tol'
                    tol = varargin{i+1};
                case 'maxit'
                    maxit = varargin{i+1};
                case 'preconditioner'
                    preconditioner_type = varargin{i+1};
                case 'verbose'
                    verbose = varargin{i+1};
            end
        end
        
        [M1, MN1] = size(B);
        [MN2, MN3] = size(H);
        [MN4, M2] = size(J);
        
        % Проверка размеров
        if MN1 ~= MN2 || MN2 ~= MN3 || MN3 ~= MN4
            error('Несовместимые размеры матриц');
        end
        if M1 ~= M2
            error('Размеры B и J не согласованы');
        end
        
        MN = MN1;
        M = M1;
        N = MN / M;
        
        if mod(N, 1) ~= 0
            error('Размер M*N должен быть кратен M');
        end
        
        if verbose
            fprintf('Размеры: M = %d, N = %d, MN = %d\n', M, N, MN);
            fprintf('Размер B: %d x %d\n', size(B));
            fprintf('Размер H: %d x %d\n', size(H));
            fprintf('Размер J: %d x %d\n', size(J));
        end
        
        % Создание предобусловливания
        switch lower(preconditioner_type)
            case 'none'
                if verbose, fprintf('Без предобусловливания\n'); end
                precond.L = [];
                precond.U = [];
                precond.P = [];
                precond.Q = [];
                
            case 'diag'
                if verbose, fprintf('Диагональное предобусловливание\n'); end
                D = diag(H);
                precond.L = spdiags(1./sqrt(abs(D) + eps), 0, MN, MN);
                precond.U = precond.L;
                precond.P = speye(MN);
                precond.Q = speye(MN);
                
            case 'ilu'
                if verbose, fprintf('ILU предобусловливание\n'); end
                try
                    % Попробовать разные настройки ILU
                    setup.type = 'ilutp';
                    setup.droptol = 0.01;
                    setup.thresh = 0.1;
                    [L, U, P, Q] = ilu(H, setup);
                    precond.L = L;
                    precond.U = U;
                    precond.P = P;
                    precond.Q = Q;
                catch
                    if verbose
                        fprintf('ILU не удалось, используем LU\n');
                    end
                    % Fallback на LU
                    [L, U, P] = lu(H);
                    precond.L = L;
                    precond.U = U;
                    precond.P = P;
                    precond.Q = speye(MN);
                end
                
            otherwise
                error('Неизвестный тип предобусловливания: %s', preconditioner_type);
        end
        
        % Функция-обертка для решения системы с предобусловливанием
        function x = apply_solve(b)
            x = zeros(size(b));
            
            % Решаем H*x = b для каждого столбца
            for col = 1:size(b, 2)
                if ~isempty(precond.L) && ~isempty(precond.U)
                    % С предобусловливанием
                    b_pre = precond.P * precond.Q * b(:, col);
                    [x_pre, flag, relres, iter] = bicgstab(...
                        @(y) precond.P * precond.Q * H * (precond.Q' * y), ...
                        b_pre, ...
                        tol, ...
                        maxit, ...
                        precond.L, ...
                        precond.U);
                    
                    if flag ~= 0 && verbose
                        warning('BiCGSTAB для столбца %d: flag=%d, relres=%g, iter=%d', ...
                            col, flag, relres, iter);
                    end
                    
                    x(:, col) = precond.Q' * x_pre;
                else
                    % Без предобусловливания
                    [x(:, col), flag, relres, iter] = bicgstab(...
                        H, b(:, col), tol, maxit);
                    
                    if flag ~= 0 && verbose
                        warning('BiCGSTAB для столбца %d: flag=%d, relres=%g, iter=%d', ...
                            col, flag, relres, iter);
                    end
                end
            end
        end
        
        % Основной расчет: S = B * inv(H) * J
        % Вместо прямого вычисления inv(H) * J, решаем H * X = J для X
        
        if verbose
            fprintf('Решение системы H*X = J...\n');
            tic;
        end
        
        % Решаем H * X = J
        X = apply_solve(J);
        
        if verbose
            elapsed_time = toc;
            fprintf('Решение системы заняло %.2f секунд\n', elapsed_time);
            fprintf('Умножение B * X...\n');
            tic;
        end
        
        % Вычисляем S = B * X
        S = B * X;
        
        if verbose
            elapsed_time = toc;
            fprintf('Умножение заняло %.2f секунд\n', elapsed_time);
            fprintf('Размер S: %d x %d\n', size(S));
        end
    end

end