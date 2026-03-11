function FUNCTIONS = functionCalc(obj)
    M  = obj.maxHarmNum;
    % N  = obj.shapeGridSize;
    n1 = obj.refrIndexOut;
    n2 = obj.refrIndexIn;
    r0 = obj.sizeParam;
    P = obj.maxPertStep;

    M_expand = M + P + 1;
    m_arr = (-M_expand:M_expand+1);
    m_indices = m_arr + M_expand + 1;

    p = obj.shapeGridSize;
    phiArr = linspace(0, 2*pi, p+1);
    phiArr = phiArr(1:end-1);

    f  = obj.shape;      % вектор
    fD = obj.shDer;      % вектор
    r1 = n1 * r0 * f;
    r2 = n2 * r0 * f;

    alpha_arr_1 = zeros([P + 2, 2 * M +  2, p]); % d^p / dr^p besselj(m, r)
    alpha_arr_2 = zeros([P + 2, 2 * M + 2, p]); % d^p / d(n*r)^p besselj(m, n*r)
    beta_arr = zeros([P + 2, 2 * M + 2, p]); % d^p / dr^p besselh(m, r)
    eta_arr_1 = zeros([P + 2, 2 * M + 1, p]); % d^p / dr^p besselj(m, r) / r
    eta_arr_2 = zeros([P + 2, 2 * M + 1, p]); % d^p / d(n*r)^p besselj(m, n*r) / (n*r)
    sigma_arr = zeros([P + 2, 2 * M + 1, p]); % d^p / dr^p besselh(m, r) / r

    alpha_arr_temp_1 = zeros([2, 2 * M + 1, p]);
    alpha_arr_temp_2 = zeros([2, 2 * M + 1, p]);
    beta_arr_temp = zeros([2, 2 * M + 1, p]);

    for m = m_indices
        alpha_arr_temp_1(1, m, :) = besselj(m_arr(m), r1);
        alpha_arr_temp_2(1, m, :) = besselj(m_arr(m), r2);
        beta_arr_temp(1, m, :) = besselh(m_arr(m),    r1);
    end

    alpha_arr_1(1, :, :) = alpha_arr_temp_1(1, (P + 1 + 1):(2*M + 1 + P + 1 + 1), :);
    alpha_arr_2(1, :, :) = alpha_arr_temp_2(1, (P + 1 + 1):(2*M + 1 + P + 1 + 1), :);
    beta_arr(1, :, :) = beta_arr_temp(1, (P + 1 + 1):(2*M + 1 + P + 1 + 1), :);

    for p = (2:(P+2))
        for m = m_indices(p:(end-p+1))
            alpha_arr_temp_1(2, m, :) = 0.5 * n1 * (alpha_arr_temp_1(1, m-1, :) - alpha_arr_temp_1(1, m+1, :));
            alpha_arr_temp_2(2, m, :) = 0.5 * n2 * (alpha_arr_temp_2(1, m-1, :) - alpha_arr_temp_2(1, m+1, :));
            beta_arr_temp(2, m, :)    = 0.5 * n1 * (beta_arr_temp(1, m-1, :)    - beta_arr_temp(1, m+1, :));
        end

        alpha_arr_1(p, :, :) = alpha_arr_temp_1(2, (P + 1 + 1):(2*M + 1 + P + 1 + 1), :);
        alpha_arr_2(p, :, :) = alpha_arr_temp_2(2, (P + 1 + 1):(2*M + 1 + P + 1 + 1), :);
        beta_arr(p, :, :) = beta_arr_temp(2, (P + 1 + 1):(2*M + 1 + P + 1 + 1), :);

        alpha_arr_temp_1(1, :, :) = alpha_arr_temp_1(2, :, :);
        alpha_arr_temp_2(1, :, :) = alpha_arr_temp_2(2, :, :);
        beta_arr_temp(1, :, :) = beta_arr_temp(2, :, :);
    end

    for p = (1:P+1)
        for m = cat(2, (1:M), (M+2:2*M+1))
            eta_arr_1(p, m, :) = reshape(alpha_arr_1(p+1, m, :) + ...
                alpha_arr_1(p, m+1, :), 1, []) / (m - 1 - M);
            eta_arr_2(p, m, :) = reshape(alpha_arr_2(p+1, m, :) + ...
                alpha_arr_2(p, m+1, :), 1, []) / (m - 1 - M);
            sigma_arr(p, m, :) = reshape(beta_arr(p+1, m, :) + ...
                beta_arr(p, m+1, :), 1, []) / (m - 1 - M);
        end
    end

    FUNCTIONS.alpha_arr_1 = alpha_arr_1(:,1:end-1,:);
    FUNCTIONS.alpha_arr_2 = alpha_arr_2(:,1:end-1,:);
    FUNCTIONS.beta_arr = beta_arr(:,1:end-1,:);
    FUNCTIONS.eta_arr_1 = eta_arr_1;
    FUNCTIONS.eta_arr_2 = eta_arr_2;
    FUNCTIONS.sigma_arr = sigma_arr;
    FUNCTIONS.phi_arr = r1;
end



