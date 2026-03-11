function oldEBCM(obj)
M = obj.maxHarmNum;
points = obj.shapeGridSize;
n1 = obj.refrIndexOut;
n2 = obj.refrIndexIn;
r0 = obj.sizeParam;
f = obj.shape;
fD = obj.shDer;
Q1 = zeros([2*M + 1, 2*M + 1]);
Q2 = Q1;

phiArr = linspace(0, 2*pi, obj.shapeGridSize + 1);
phiArr = phiArr(1:end-1);

P = 1;
M_expand = M + P + 1;
m_arr = (-M_expand:M_expand + 1);
m_indices = m_arr + M_expand + 1;

alpha_arr_1 = zeros([P + 1, 2 * M + 2, points]);
alpha_arr_2 = zeros([P + 1, 2 * M + 2, points]);
beta_arr = zeros([P + 1, 2 * M + 2, points]);
eta_arr_1 = zeros([P, 2 * M + 1, points]);
eta_arr_2 = zeros([P, 2 * M + 1, points]);
sigma_arr = zeros([P, 2 * M + 1, points]);

alpha_arr_temp_1 = zeros([2, 2 * M_expand + 1, points]);
alpha_arr_temp_2 = zeros([2, 2 * M_expand + 1, points]);
beta_arr_temp = zeros([2, 2 * M_expand + 1, points]);

for m = m_indices
    alpha_arr_temp_1(1, m, :) = besselj(m_arr(m), n1*r0*f);
    alpha_arr_temp_2(1, m, :) = besselj(m_arr(m), n2*r0*f);
    beta_arr_temp(1, m, :)    = besselh(m_arr(m), n1*r0*f);
end

alpha_arr_1(1, :, :) = alpha_arr_temp_1(1, (P + 1 + 1):(2 * M + 1 + P + 1 + 1), :);
alpha_arr_2(1, :, :) = alpha_arr_temp_2(1, (P + 1 + 1):(2 * M + 1 + P + 1 + 1), :);
beta_arr(1, :, :)    = beta_arr_temp(1, (P + 1 + 1):(2 * M + 1 + P + 1 + 1), :);

for p = (2:(P + 2))
    
    for m = m_indices(p:(end - p + 1))
        alpha_arr_temp_1(2, m, :) = 0.5 * (alpha_arr_temp_1(1, m - 1, :) - alpha_arr_temp_1(1, m + 1, :));
        alpha_arr_temp_2(2, m, :) = 0.5 * (alpha_arr_temp_2(1, m - 1, :) - alpha_arr_temp_2(1, m + 1, :));
        beta_arr_temp(2, m, :) = 0.5 * (beta_arr_temp(1, m - 1, :) - beta_arr_temp(1, m + 1, :));
    end
    
    alpha_arr_1(p, :, :) = alpha_arr_temp_1(2, (P + 1 + 1):(2 * M + 1 + P + 1 + 1), :);
    alpha_arr_2(p, :, :) = alpha_arr_temp_2(2, (P + 1 + 1):(2 * M + 1 + P + 1 + 1), :);
    beta_arr(p, :, :) = beta_arr_temp(2, (P + 1 + 1):(2 * M + 1 + P + 1 + 1), :);
    
    alpha_arr_temp_1(1, :, :) = alpha_arr_temp_1(2, :, :);
    alpha_arr_temp_2(1, :, :) = alpha_arr_temp_2(2, :, :);
    beta_arr_temp(1, :, :) = beta_arr_temp(2, :, :);
end

clear alpha_arr_temp_1 alpha_arr_temp_2 beta_arr_temp

for p = (1:P)
    
    for m = cat(2, (1:M), (M + 2:2 * M + 1))
        eta_arr_1(p, m, :) = reshape(alpha_arr_1(p + 1, m, :) + ...
            alpha_arr_1(p, m + 1, :), 1, []) / (m - 1 - M);
        eta_arr_2(p, m, :) = reshape(alpha_arr_2(p + 1, m, :) + ...
            alpha_arr_2(p, m + 1, :), 1, []) / (m - 1 - M);
        sigma_arr(p, m, :) = reshape(beta_arr(p + 1, m, :) + ...
            beta_arr(p, m + 1, :), 1, []) / (m - 1 - M);
    end
    
end

for m2 = (-M:M)
    
    for m1 = (-M:M)
        % a_0_m1 = reshape(alpha_arr_1(1, m1+M+1, :), 1, []);
        % a_1_m1 = reshape(alpha_arr_1(2, m1+M+1, :), 1, []);
        A_0_m1 = reshape(alpha_arr_2(1, m1 + M + 1, :), 1, []);
        A_1_m1 = reshape(alpha_arr_2(2, m1 + M + 1, :), 1, []);
        
        a_0_m2 = reshape(alpha_arr_1(1, m2 + M + 1, :), 1, []);
        a_1_m2 = reshape(alpha_arr_1(2, m2 + M + 1, :), 1, []);
        % A_0_m2 = reshape(alpha_arr_2(1, m2+M+1, :), 1, []);
        % A_1_m2 = reshape(alpha_arr_2(2, m2+M+1, :), 1, []);
        
        b_0_m2 = reshape(beta_arr(1, m2 + M + 1, :), 1, []);
        b_1_m2 = reshape(beta_arr(2, m2 + M + 1, :), 1, []);
        
        eta_m2 = reshape(eta_arr_1(1, m2 + M + 1, :), 1, []);
        % eta_m1 = reshape(eta_arr_1(1, m1+M+1, :), 1, []);
        Eta_m1 = reshape(eta_arr_2(1, m1 + M + 1, :), 1, []);
        
        sig_m2 = reshape(sigma_arr(1, m2 + M + 1, :), 1, []);
        
        Q1(m2 + M + 1, m1 + M + 1) = -0.25j * r0 .* trapz(phiArr, (n1 * A_0_m1 .* (b_1_m2 .* f + 1j * m2 * sig_m2 .* fD) - ...
            n2 * b_0_m2 .* (A_1_m1 .* f - 1j * m1 * Eta_m1 .* fD)) .* ...
            exp(1j * (m1 - m2) * phiArr));
        
        Q2(m2 + M + 1, m1 + M + 1) = 0.25j * r0 .* trapz(phiArr, (n1 * A_0_m1 .* (a_1_m2 .* f + 1j * m2 * eta_m2 .* fD) - ...
            n2 * a_0_m2 .* (A_1_m1 .* f - 1j * m1 * Eta_m1 .* fD)) .* ...
            exp(1j * (m1 - m2) * phiArr));
    end
    
end

obj.intMatrix = inv(Q1);
obj.scaMatrix = (Q2 / Q1).';
obj.intCoeffs = obj.intMatrix * obj.incCoeffs;
obj.scaCoeffs = obj.scaMatrix * obj.incCoeffs;

% obj.intCoeffs = bicgstab(Q1, obj.incCoeffs, 1e-5, 3000);
% obj.scaCoeffs = (Q2 * obj.intCoeffs);



end