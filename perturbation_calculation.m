global PARAMS COEFFS FUNCTIONS

alpha = 0;
N = 15;
errors = zeros(1,N);

M = PARAMS.M;
P = PARAMS.P;
Nm = 2*M+1;

a = 0;
b = 2*pi;

m_vals = -M:M;
phi_arr = phi_arr_creator(PARAMS.int_points);

%% ==========================================================
%% ПРЕДВЫЧИСЛЕНИЕ ЭКСПОНЕНТ
%% ==========================================================

deltaM = -2*M:2*M;
EXP_TABLE = exp(1j * (deltaM.') * phi_arr);   % (4M+1) x Nphi

%% ==========================================================
%% ПРЕДВЫЧИСЛЕНИЕ ФАКТОРИАЛОВ И СТЕПЕНЕЙ
%% ==========================================================

fact_arr = factorial(0:P);

base1 = PARAMS.r0 * PARAMS.f1_arr;
base2 = PARAMS.nrefr;

pow1 = zeros(P,length(base1));
pow2 = zeros(P,length(base1));

for q = 1:P
    pow1(q,:) = base1.^q;
    pow2(q,:) = pow1(q,:) * (base2^q);
end

%% ==========================================================
%% ОСНОВНОЙ ЦИКЛ ПО ШАГАМ
%% ==========================================================

for n = 1:N

    PARAMS.f1_coeffs = f1_coeffs / N;

    function_calculation(phi_arr, alpha);

    alpha2 = FUNCTIONS.alpha_arr_2;
    beta   = FUNCTIONS.beta_arr;
    eta2   = FUNCTIONS.eta_arr_2;
    sigma  = FUNCTIONS.sigma_arr;

    %% ======================================================
    %% ВЫЧИСЛЕНИЕ ИНТЕГРАЛОВ
    %% ======================================================

    integrals = zeros(10,P,Nm,Nm);

    for m1i = 1:Nm

        m1 = m_vals(m1i);

        for m2i = 1:Nm

            exponent = EXP_TABLE(m1-m_vals(m2i)+2*M+1,:);

            for q = 1:P

                fact = fact_arr(q+1);
                pow_1 = pow1(q,:);
                pow_2 = pow2(q,:);

                beta0 = squeeze(beta(q+1,m1i,:)).';
                alph0 = squeeze(alpha2(q+1,m1i,:)).';
                beta1 = squeeze(beta(q+2,m1i,:)).';
                alph1 = squeeze(alpha2(q+2,m1i,:)).';
                sig   = squeeze(sigma(q+1,m1i,:)).';
                eta_  = squeeze(eta2(q+1,m1i,:)).';

                integrals(1,q,m1i,m2i) = trapz(phi_arr,beta0.*exponent.*pow_1/fact)/(2*pi);
                integrals(2,q,m1i,m2i) = trapz(phi_arr,alph0.*exponent.*pow_2/fact)/(2*pi);
                integrals(3,q,m1i,m2i) = trapz(phi_arr,PARAMS.f0_arr.*beta1.*exponent.*pow_1/fact)/(2*pi);
                integrals(4,q,m1i,m2i) = trapz(phi_arr,PARAMS.f1_arr.*beta1.*exponent.*pow_1/fact)/(2*pi);
                integrals(5,q,m1i,m2i) = trapz(phi_arr,1j*m1*PARAMS.f0_der_arr.*sig.*exponent.*pow_1/fact)/(2*pi);
                integrals(6,q,m1i,m2i) = trapz(phi_arr,1j*m1*PARAMS.f1_der_arr.*sig.*exponent.*pow_1/fact)/(2*pi);
                integrals(7,q,m1i,m2i) = trapz(phi_arr,PARAMS.f0_arr.*alph1.*exponent.*pow_2/fact)/(2*pi);
                integrals(8,q,m1i,m2i) = trapz(phi_arr,PARAMS.f1_arr.*alph1.*exponent.*pow_2/fact)/(2*pi);
                integrals(9,q,m1i,m2i) = trapz(phi_arr,1j*m1*PARAMS.f0_der_arr.*eta_.*exponent.*pow_2/fact)/(2*pi);
                integrals(10,q,m1i,m2i)= trapz(phi_arr,1j*m1*PARAMS.f1_der_arr.*eta_.*exponent.*pow_2/fact)/(2*pi);

            end
        end
    end

    %% ======================================================
    %% НОВАЯ МАТРИЦА РАССЕЯНИЯ
    %% ======================================================

    new_scat_matrix = zeros(size(PARAMS.scat_matrix));

    for col = 1:2*Nm

        pseudo = zeros(2*Nm,1);
        pseudo(col)=1;

        coeffs = PARAMS.scat_matrix * pseudo;
        sca_coeffs = zeros(P+1,Nm);
        int_coeffs = zeros(P+1,Nm);

        sca_coeffs(1,:) = coeffs(1:Nm);
        int_coeffs(1,:) = coeffs(Nm+1:end);

        for p = 1:P

            stl_temp = zeros(1,2*Nm);

            for q = 0:p-1

                I1 = squeeze(integrals(1,p-q,:,:));
                I2 = squeeze(integrals(2,p-q,:,:));

                part1 = sca_coeffs(q+1,:)*I1 ...
                      - int_coeffs(q+1,:)*I2;

                I34 = squeeze(integrals(3,p-q,:,:)) ...
                    + squeeze(integrals(4,p-q,:,:)) ...
                    - squeeze(integrals(5,p-q,:,:)) ...
                    - squeeze(integrals(6,p-q,:,:));

                I78 = squeeze(integrals(7,p-q,:,:)) ...
                    + squeeze(integrals(8,p-q,:,:)) ...
                    - squeeze(integrals(9,p-q,:,:)) ...
                    - squeeze(integrals(10,p-q,:,:));

                part2 = sca_coeffs(q+1,:)*I34 ...
                      - int_coeffs(q+1,:)*PARAMS.nrefr*I78;

                stl_temp(1:Nm)     = stl_temp(1:Nm)     - part1;
                stl_temp(Nm+1:end) = stl_temp(Nm+1:end) - part2;
            end

            coeffs = PARAMS.scat_matrix * stl_temp.';
            sca_coeffs(p+1,:) = coeffs(1:Nm);
            int_coeffs(p+1,:) = coeffs(Nm+1:end);
        end

        sca_coeffs(1,:) = sum(sca_coeffs,1);
        int_coeffs(1,:) = sum(int_coeffs,1);

        new_scat_matrix(1:Nm,col)     = sca_coeffs(1,:);
        new_scat_matrix(Nm+1:end,col) = int_coeffs(1,:);
    end

    PARAMS.scat_matrix = new_scat_matrix;

    coeffs = PARAMS.scat_matrix * st0_coeffs.';
    COEFFS.sca_coeffs(1,:) = coeffs(1:Nm);
    COEFFS.int_coeffs(1,:) = coeffs(Nm+1:end);

    errors(n) = check_condition();

    if errors(n) > 1e3
        error('BLOW UP');
    end

    PARAMS.f0_coeffs = PARAMS.f0_coeffs + PARAMS.f1_coeffs;

    if mod(n,3)==0
        plotter(400);
    end

    figure(25)
    plot(1:n,errors(1:n))
    set(gca,'YScale','log')
    drawnow
end