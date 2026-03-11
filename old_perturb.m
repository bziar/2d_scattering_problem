global PARAMS COEFFS FUNCTIONS

alpha = 0;

N = 15;
% % Delta = 0.15;
% % delta = Delta / N;
% % 
% % f1_coeffs = 0 * PARAMS.f1_coeffs;
% % 
% % f1_coeffs(2) = delta;
% % f1_coeffs(5) = delta;
% % f1_coeffs(5) = delta;
% % f1_coeffs(10) = delta;
% % f1_coeffs(13) = -delta;

% f1_coeffs = square_coeffs / N;

% N = ceil(max(abs(f1_coeffs)) / 0.015);
errors = zeros([1, N]);
a = 0;
b = 2*pi;

for n = (1:N)
    
    f0_coeffs = PARAMS.f0_coeffs;
    PARAMS.f1_coeffs = f1_coeffs / N;

    % PARAMS.f1_coeffs = f1_coeffs * (exp(1j * pi * (1 + n/N)) - exp(1j * pi * (1 + (n-1)/N)));

    inc_coeffs = COEFFS.inc_coeffs;
    sca_coeffs = COEFFS.sca_coeffs;
    int_coeffs = COEFFS.int_coeffs;
    
    phi_arr = phi_arr_creator(PARAMS.int_points);
    function_calculation(phi_arr, alpha);
    
    alpha_arr_1 = FUNCTIONS.alpha_arr_1;
    alpha_arr_2 = FUNCTIONS.alpha_arr_2;
    beta_arr = FUNCTIONS.beta_arr;
    eta_arr_1 = FUNCTIONS.eta_arr_1;
    eta_arr_2 = FUNCTIONS.eta_arr_2;
    sigma_arr = FUNCTIONS.sigma_arr;
    

    %% INTEGRALS
    integrals = zeros([10, P, 2*M+1, 2*M+1]);
    for m1 = (-M:M)
        for m2 = (-M:M)

            exponent = exp(1j * (m1-m2) * phi_arr);
            
            q = 0;
            beta_1 = reshape(beta_arr(q+2, m1+M+1, :), 1, []);
            alph_1 = reshape(alpha_arr_2(q+2, m1+M+1, :), 1, []);
            sigma_ = reshape(sigma_arr(q+1, m1+M+1, :), 1, []);
            eta___ = reshape(eta_arr_2(q+1, m1+M+1, :), 1, []);

            integrals(4 , q+1, m1+M+1, m2+M+1) = integration(PARAMS.f1_arr .* beta_1 .* exponent, a, b) / (2 * pi);
            integrals(6 , q+1, m1+M+1, m2+M+1) = integration(1j * m1 * PARAMS.f1_der_arr .* sigma_ .* exponent, a, b) / (2 * pi);
            integrals(8 , q+1, m1+M+1, m2+M+1) = integration(PARAMS.f1_arr .* alph_1 .* exponent, a, b) / (2 * pi);
            integrals(10, q+1, m1+M+1, m2+M+1) = integration(1j * m1 * PARAMS.f1_der_arr .* eta___ .* exponent, a, b) / (2 * pi);


            for q = (1:P-1)

                fact = factorial(q);
                pow_1 = (PARAMS.r0 * PARAMS.f1_arr).^q;
                pow_2 = pow_1 * (PARAMS.nrefr)^q;
                
                beta_0 = reshape(beta_arr(q+1, m1+M+1, :), 1, []);
                alph_0 = reshape(alpha_arr_2(q+1, m1+M+1, :), 1, []);
                beta_1 = reshape(beta_arr(q+2, m1+M+1, :), 1, []);
                alph_1 = reshape(alpha_arr_2(q+2, m1+M+1, :), 1, []);
                sigma_ = reshape(sigma_arr(q+1, m1+M+1, :), 1, []);
                eta___ = reshape(eta_arr_2(q+1, m1+M+1, :), 1, []);

                integrals(1 , q  , m1+M+1, m2+M+1) = integration(beta_0 .* exponent .* pow_1 / fact, a, b) / (2 * pi);
                integrals(2 , q  , m1+M+1, m2+M+1) = integration(alph_0 .* exponent .* pow_2 / fact, a, b) / (2 * pi);
                integrals(3 , q  , m1+M+1, m2+M+1) = integration(PARAMS.f0_arr .* beta_1 .* exponent .* pow_1 / fact, a, b) / (2 * pi);
                integrals(4 , q+1, m1+M+1, m2+M+1) = integration(PARAMS.f1_arr .* beta_1 .* exponent .* pow_1 / fact, a, b) / (2 * pi);
                integrals(5 , q  , m1+M+1, m2+M+1) = integration(1j * m1 * PARAMS.f0_der_arr .* sigma_ .* exponent .* pow_1 / fact, a, b) / (2 * pi);
                integrals(6 , q+1, m1+M+1, m2+M+1) = integration(1j * m1 * PARAMS.f1_der_arr .* sigma_ .* exponent .* pow_1 / fact, a, b) / (2 * pi);
                integrals(7 , q  , m1+M+1, m2+M+1) = integration(PARAMS.f0_arr .* alph_1 .* exponent .* pow_2 / fact, a, b) / (2 * pi);
                integrals(8 , q+1, m1+M+1, m2+M+1) = integration(PARAMS.f1_arr .* alph_1 .* exponent .* pow_2 / fact, a, b) / (2 * pi);
                integrals(9 , q  , m1+M+1, m2+M+1) = integration(1j * m1 * PARAMS.f0_der_arr .* eta___ .* exponent .* pow_2 / fact, a, b) / (2 * pi);
                integrals(10, q+1, m1+M+1, m2+M+1) = integration(1j * m1 * PARAMS.f1_der_arr .* eta___ .* exponent .* pow_2 / fact, a, b) / (2 * pi);
            end
            
            q = P;
            fact = factorial(q);
            pow_1 = (PARAMS.r0 * PARAMS.f1_arr).^q;
            pow_2 = pow_1 * (PARAMS.nrefr)^q;
            
            beta_0 = reshape(beta_arr(q+1, m1+M+1, :), 1, []);
            alph_0 = reshape(alpha_arr_2(q+1, m1+M+1, :), 1, []);
            beta_1 = reshape(beta_arr(q+2, m1+M+1, :), 1, []);
            alph_1 = reshape(alpha_arr_2(q+2, m1+M+1, :), 1, []);
            sigma_ = reshape(sigma_arr(q+1, m1+M+1, :), 1, []);
            eta___ = reshape(eta_arr_2(q+1, m1+M+1, :), 1, []);

            integrals(1 , q, m1+M+1, m2+M+1) = integration(beta_0 .* exponent .* pow_1 / fact, a, b) / (2 * pi);
            integrals(2 , q, m1+M+1, m2+M+1) = integration(alph_0 .* exponent .* pow_2 / fact, a, b) / (2 * pi);
            integrals(3 , q, m1+M+1, m2+M+1) = integration(PARAMS.f0_arr .* beta_1 .* exponent .* pow_1 / fact, a, b) / (2 * pi);
            integrals(5 , q, m1+M+1, m2+M+1) = integration(1j * m1 * PARAMS.f0_der_arr .* sigma_ .* exponent .* pow_1 / fact, a, b) / (2 * pi);
            integrals(7 , q, m1+M+1, m2+M+1) = integration(PARAMS.f0_arr .* alph_1 .* exponent .* pow_2 / fact, a, b) / (2 * pi);
            integrals(9 , q, m1+M+1, m2+M+1) = integration(1j * m1 * PARAMS.f0_der_arr .* eta___ .* exponent .* pow_2 / fact, a, b) / (2 * pi);

        end
    end



    %%

    new_scat_matrix = 0 * PARAMS.scat_matrix;

    
    phi_arr = phi_arr_creator(PARAMS.int_points);
    function_creator(phi_arr, alpha);

    inc_field_surf = zeros(size(PARAMS.f_arr));
    der_inc_field_surf = zeros(size(PARAMS.f_arr));

    surface = PARAMS.r0 * PARAMS.f_arr;
    st0_coeffs = zeros([1, 2*(2*M+1)]);

    for m = (-M:M)

        exponent = exp(1j * m * phi_arr);
        bes = besselj(m, surface);
        inc_field_surf = inc_field_surf - inc_coeffs(m+M+1) * exponent .* bes;
        der_inc_field_surf = der_inc_field_surf - inc_coeffs(m+M+1) .* exponent .* ...
            (PARAMS.f_arr .* 0.5 .* (besselj(m-1, surface) - besselj(m+1, surface)) - ...
            1j .* m .* PARAMS.f_der_arr .* bes ./ surface);
    end

    for m = (-M:M)

        i1 = inc_field_surf .* exp(-1j * m * phi_arr);
        i2 = der_inc_field_surf .* exp(-1j * m * phi_arr);

        st0_coeffs(m+M+1        ) = integration(i1, 0, 2*pi) / (2 * pi);
        st0_coeffs(m+M+1+(2*M+1)) = integration(i2, 0, 2*pi) / (2 * pi);

    end

    for col = (1:2*(2*M+1))
        disp('Pert progress: ' + string(n) + '/' + string(N));
        disp(string(col) + '/' + string(2*(2*M+1)));

        pseudo_stl = zeros([1, 2*(2*M+1)]);
        pseudo_stl(col) = 1;

        coeffs = PARAMS.scat_matrix * pseudo_stl.';
        sca_coeffs(1, :) = coeffs(1:2*M+1);
        int_coeffs(1, :) = coeffs(2*M+2:end);

        for p = (1:P)

            stl_coeffs_temp = zeros([1, 2*(2*M+1)]);

            for m1 = (1:(2*M+1))
                for m2 = (1:(2*M+1))
                    for q = (0:p-1)
                        stl_coeffs_temp(m2        ) = stl_coeffs_temp(m2        ) - ...
                            (sca_coeffs(q+1, m1) * integrals(1, p-q, m1, m2) - int_coeffs(q+1, m1) * integrals(2, p-q, m1, m2));
                        stl_coeffs_temp(m2+(2*M+1)) = stl_coeffs_temp(m2+(2*M+1)) - ...
                            (sca_coeffs(q+1, m1) * ...
                            (integrals(3, p-q, m1, m2) + integrals(4, p-q, m1, m2) - integrals(5, p-q, m1, m2) - integrals(6, p-q, m1, m2)) - ...
                            int_coeffs(q+1, m1) * PARAMS.nrefr * ...
                            (integrals(7, p-q, m1, m2) + integrals(8, p-q, m1, m2) - integrals(9, p-q, m1, m2) - integrals(10, p-q, m1, m2)) ...
                            );
                    end
                end
            end
        
            coeffs = PARAMS.scat_matrix * stl_coeffs_temp.';
            sca_coeffs(p+1, :) = coeffs(1:2*M+1);
            int_coeffs(p+1, :) = coeffs(2*M+2:end);
           
        end

        for m = (1:2*M+1)

            sca_coeffs(1, m) = sum(reshape(sca_coeffs(:, m), 1, []));
            int_coeffs(1, m) = sum(reshape(int_coeffs(:, m), 1, []));

        end

        new_scat_matrix(1:2*M+1, col) = sca_coeffs(1, :);
        new_scat_matrix(2*M+2:end, col) = int_coeffs(1, :);

        clc
    end

    PARAMS.scat_matrix = new_scat_matrix;

    coeffs = PARAMS.scat_matrix * st0_coeffs.';
    COEFFS.sca_coeffs(1, :) = coeffs(1:2*M+1);
    COEFFS.int_coeffs(1, :) = coeffs(2*M+2:end);
    
    errors(n) = check_condition();

    if (errors(n) > 1e3)
        error('BLOW UP');
    end

    PARAMS.f0_coeffs = PARAMS.f0_coeffs + PARAMS.f1_coeffs;

    if mod(n, 3) == 0
        plotter(400);    
    end

    clc
    
    figure(25)
    plot((1:n), errors(1:n))
    set(gca, 'YScale', 'log')
    title('Error')
    xlabel('Iteration')
    ylabel('Condition')
    drawnow

end

clear coeffs integrals

PARAMS.f0_coeffs = 0 * PARAMS.f0_coeffs;
PARAMS.f0_coeffs(2) = 1;
PARAMS.f1_coeffs = f1_coeffs;
plotter(400);

% disp('Difference sca: ' + string(abs(sum((old_sca - COEFFS{2}(1, :)).^2))))
% disp('Difference int: ' + string(abs(sum((old_int - COEFFS{3}(1, :)).^2))))

% PARAMS_2 = PARAMS;
% PARAMS_2.f1_coeffs = 0 * f1_coeffs;
% PARAMS_2.r0 = r0*(1 + N*f1_coeffs(2));
% 
% [scat_matrix_2, COEFFS_2] = initialization(PARAMS_2);
% 
% disp('New difference sca: ' + string(abs(sum((COEFFS_2{2}(1,:) - COEFFS{2}(1, :)).^2))))
% disp('New difference int: ' + string(abs(sum((COEFFS_2{3}(1,:) - COEFFS{3}(1, :)).^2))))















