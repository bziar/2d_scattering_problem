function obj = perturbStep(obj, f1Coeffs)

% f1Coeffs = obj.newShapeCoeffs;

M  = obj.maxHarmNum;
% N  = obj.shapeGridSize;
n1 = obj.refrIndexOut;
n2 = obj.refrIndexIn;
r0 = obj.sizeParam;
P = obj.maxPertStep;

int_coeffs = zeros(P+1, 2*M+1);
sca_coeffs = zeros(P+1, 2*M+1);

inc_coeffs = obj.incCoeffs;
sca_coeffs(1, :) = obj.scaCoeffs;
int_coeffs(1, :) = obj.intCoeffs;

p = obj.shapeGridSize;
phi_arr = linspace(0, 2*pi, p+1);
phi_arr = phi_arr(1:end-1);
FUNCTIONS = obj.functionCalc();

% alpha_arr_1 = FUNCTIONS.alpha_arr_1;
alpha_arr_2 = FUNCTIONS.alpha_arr_2;
beta_arr = FUNCTIONS.beta_arr;
% eta_arr_1 = FUNCTIONS.eta_arr_1;
eta_arr_2 = FUNCTIONS.eta_arr_2;
sigma_arr = FUNCTIONS.sigma_arr;

f  = obj.shape;
fD = obj.shDer;

f1 = zeros(1, numel(phi_arr));
f1Der = zeros(1, numel(phi_arr));
for k = 1:obj.maxShapeCoeffsNum
    f1 = f1 + f1Coeffs(2*k-1) * sin(k * phi_arr) + f1Coeffs(2*k) * cos(k * phi_arr);
    f1Der = f1Der + k * (f1Coeffs(2*k-1) * cos(k * phi_arr) - f1Coeffs(2*k) * sin(k * phi_arr));
end

clear FUNCTIONS;

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

        integrals(4 , q+1, m1+M+1, m2+M+1) = trapz(phi_arr, f1 .* beta_1 .* exponent) / (2 * pi);
        integrals(6 , q+1, m1+M+1, m2+M+1) = trapz(phi_arr, 1j * m1 * f1Der .* sigma_ .* exponent) / (2 * pi);
        integrals(8 , q+1, m1+M+1, m2+M+1) = trapz(phi_arr, f1 .* alph_1 .* exponent) / (2 * pi);
        integrals(10, q+1, m1+M+1, m2+M+1) = trapz(phi_arr, 1j * m1 * f1Der .* eta___ .* exponent) / (2 * pi);


        for q = (1:P-1)

            fact = factorial(q);
            pow_1 = (r0 * f1).^q;
            pow_2 = pow_1 * (n2)^q;
            
            beta_0 = reshape(beta_arr(q+1, m1+M+1, :), 1, []);
            alph_0 = reshape(alpha_arr_2(q+1, m1+M+1, :), 1, []);
            beta_1 = reshape(beta_arr(q+2, m1+M+1, :), 1, []);
            alph_1 = reshape(alpha_arr_2(q+2, m1+M+1, :), 1, []);
            sigma_ = reshape(sigma_arr(q+1, m1+M+1, :), 1, []);
            eta___ = reshape(eta_arr_2(q+1, m1+M+1, :), 1, []);

            integrals(1 , q  , m1+M+1, m2+M+1) = trapz(phi_arr, beta_0 .* exponent .* pow_1 / fact) / (2 * pi);
            integrals(2 , q  , m1+M+1, m2+M+1) = trapz(phi_arr, alph_0 .* exponent .* pow_2 / fact) / (2 * pi);
            integrals(3 , q  , m1+M+1, m2+M+1) = trapz(phi_arr, f .* beta_1 .* exponent .* pow_1 / fact) / (2 * pi);
            integrals(4 , q+1, m1+M+1, m2+M+1) = trapz(phi_arr, f1 .* beta_1 .* exponent .* pow_1 / fact) / (2 * pi);
            integrals(5 , q  , m1+M+1, m2+M+1) = trapz(phi_arr, 1j * m1 * fD .* sigma_ .* exponent .* pow_1 / fact) / (2 * pi);
            integrals(6 , q+1, m1+M+1, m2+M+1) = trapz(phi_arr, 1j * m1 * f1Der .* sigma_ .* exponent .* pow_1 / fact) / (2 * pi);
            integrals(7 , q  , m1+M+1, m2+M+1) = trapz(phi_arr, f .* alph_1 .* exponent .* pow_2 / fact) / (2 * pi);
            integrals(8 , q+1, m1+M+1, m2+M+1) = trapz(phi_arr, f1 .* alph_1 .* exponent .* pow_2 / fact) / (2 * pi);
            integrals(9 , q  , m1+M+1, m2+M+1) = trapz(phi_arr, 1j * m1 * fD .* eta___ .* exponent .* pow_2 / fact) / (2 * pi);
            integrals(10, q+1, m1+M+1, m2+M+1) = trapz(phi_arr, 1j * m1 * f1Der .* eta___ .* exponent .* pow_2 / fact) / (2 * pi);
        end
        q = P;
        fact = factorial(q);
        pow_1 = (r0 * f1).^q;
        pow_2 = pow_1 * (n2)^q;
        
        beta_0 = reshape(beta_arr(q+1, m1+M+1, :), 1, []);
        alph_0 = reshape(alpha_arr_2(q+1, m1+M+1, :), 1, []);
        beta_1 = reshape(beta_arr(q+2, m1+M+1, :), 1, []);
        alph_1 = reshape(alpha_arr_2(q+2, m1+M+1, :), 1, []);
        sigma_ = reshape(sigma_arr(q+1, m1+M+1, :), 1, []);
        eta___ = reshape(eta_arr_2(q+1, m1+M+1, :), 1, []);

        integrals(1 , q, m1+M+1, m2+M+1) = trapz(phi_arr, beta_0 .* exponent .* pow_1 / fact) / (2 * pi);
        integrals(2 , q, m1+M+1, m2+M+1) = trapz(phi_arr, alph_0 .* exponent .* pow_2 / fact) / (2 * pi);
        integrals(3 , q, m1+M+1, m2+M+1) = trapz(phi_arr, f .* beta_1 .* exponent .* pow_1 / fact) / (2 * pi);
        integrals(5 , q, m1+M+1, m2+M+1) = trapz(phi_arr, 1j * m1 * fD .* sigma_ .* exponent .* pow_1 / fact) / (2 * pi);
        integrals(7 , q, m1+M+1, m2+M+1) = trapz(phi_arr, f .* alph_1 .* exponent .* pow_2 / fact) / (2 * pi);
        integrals(9 , q, m1+M+1, m2+M+1) = trapz(phi_arr, 1j * m1 * fD .* eta___ .* exponent .* pow_2 / fact) / (2 * pi);

    end
end
% disp(sum(sign(integrals(:))))
% integrals = -real(integrals) + imag(integrals);
plot(squeeze(real(integrals(4 , 2, 10, :))))
return
% %%

new_scat_matrix = 0 * obj.genScatMat;


inc_field_surf = zeros(size(f));
der_inc_field_surf = zeros(size(f));

surface = r0 * (f + f1);
st0_coeffs = zeros([1, 2*(2*M+1)]);

for m = (-M:M)

    exponent = exp(1j * m * phi_arr);
    bes = besselj(m, surface);
    inc_field_surf = inc_field_surf - inc_coeffs(m+M+1) * exponent .* bes;
    der_inc_field_surf = der_inc_field_surf - inc_coeffs(m+M+1) .* exponent .* ...
        ((f+f1) .* 0.5 .* (besselj(m-1, surface) - besselj(m+1, surface)) - ...
        1j .* m .* (fD + f1Der) .* bes ./ surface);
end

for m = (-M:M)

    i1 = inc_field_surf .* exp(-1j * m * phi_arr);
    i2 = der_inc_field_surf .* exp(-1j * m * phi_arr);

    st0_coeffs(m+M+1        ) = trapz(phi_arr, i1) / (2 * pi);
    st0_coeffs(m+M+1+(2*M+1)) = trapz(phi_arr, i2) / (2 * pi);

end

for col = (1:2*(2*M+1))
    % disp('Pert progress: ' + string(col) + '/' + string(N));
    disp(string(col) + '/' + string(2*(2*M+1)));

    pseudo_stl = zeros([1, 2*(2*M+1)]);
    pseudo_stl(col) = 1;

    coeffs = obj.genScatMat * pseudo_stl.';
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
                        int_coeffs(q+1, m1) * n2 * ...
                        (integrals(7, p-q, m1, m2) + integrals(8, p-q, m1, m2) - integrals(9, p-q, m1, m2) - integrals(10, p-q, m1, m2)) ...
                        );
                end
            end
        end
    
        coeffs = obj.genScatMat * stl_coeffs_temp.';
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

obj.genScatMat = new_scat_matrix;
obj.scaMatrix = obj.genScatMat(1:2*M+1, :) * obj.shapeDecompMat;

coeffs = obj.genScatMat * st0_coeffs.';
obj.scaCoeffs = coeffs(1:2*M+1);
obj.intCoeffs = coeffs(2*M+2:end);


end