function obj = perturbStep(obj, f1Coeffs)

M  = obj.maxHarmNum;
n1 = obj.refrIndexOut;
n2 = obj.refrIndexIn;
r0 = obj.sizeParam;
P  = obj.maxPertStep;

inc_coeffs = obj.incCoeffs;

sca_coeffs = zeros(P+1,2*M+1);
int_coeffs = zeros(P+1,2*M+1);

sca_coeffs(1,:) = obj.scaCoeffs;
int_coeffs(1,:) = obj.intCoeffs;

p = obj.shapeGridSize;

phi_arr = linspace(0,2*pi,p+1);
phi_arr(end) = [];

dphi = phi_arr(2)-phi_arr(1);

m_vec = -M:M;
Nm = 2*M+1;

FUNCTIONS = obj.functionCalc();

alpha_arr_2 = FUNCTIONS.alpha_arr_2;
beta_arr    = FUNCTIONS.beta_arr;
eta_arr_2   = FUNCTIONS.eta_arr_2;
sigma_arr   = FUNCTIONS.sigma_arr;

f  = obj.shape;
fD = obj.shDer;

%% Fourier shape perturbation

f1 = zeros(1,p);
f1Der = zeros(1,p);

K = obj.maxShapeCoeffsNum;

k = 1:K;

S = sin(k.'*phi_arr);
C = cos(k.'*phi_arr);

f1 = f1Coeffs(1:2:end)*S + f1Coeffs(2:2:end)*C;

f1Der = (k.*f1Coeffs(1:2:end))*C - (k.*f1Coeffs(2:2:end))*S;

%% power terms

rf1 = r0*f1;

pow1 = zeros(P+1,p);
pow1(1,:) = 1;

for q=1:P
    pow1(q+1,:) = pow1(q,:).*rf1;
end

pow2 = zeros(P+1,p);

for q=0:P
    pow2(q+1,:) = pow1(q+1,:)*(n2^q);
end

fact = factorial(0:P);
inv_fact = 1./fact;

%% exponentials

Epos = exp(1i*(m_vec.')*phi_arr);
Eneg = exp(-1i*(m_vec.')*phi_arr);

%% integrals

integrals = zeros(6,P,Nm,Nm);

for m1i = 1:Nm

    m1 = m_vec(m1i);
    k_idx = mod(m1 - m_vec, p) + 1;
    beta_m = squeeze(beta_arr(:,m1i,:));
    alph_m = squeeze(alpha_arr_2(:,m1i,:));
    sigma_m = squeeze(sigma_arr(:,m1i,:));
    eta_m = squeeze(eta_arr_2(:,m1i,:));

    %% q = 0

    beta1 = beta_m(2,:);
    alph1 = alph_m(2,:);
    sigma = sigma_m(1,:);
    eta   = eta_m(1,:);

    gq0 = [
        f1 .* beta1 - 1i*m1*f1Der .* sigma;
        f1 .* alph1 - 1i*m1*f1Der .* eta
    ];
    c0 = ifft(gq0, [], 2);

    integrals(4,1,m1i,:) = c0(1,k_idx);
    integrals(6,1,m1i,:) = c0(2,k_idx);

    %% q = 1..P-1

    for q = 1:P-1

        beta0 = beta_m(q+1,:);
        alph0 = alph_m(q+1,:);
        beta1 = beta_m(q+2,:);
        alph1 = alph_m(q+2,:);
        sigma = sigma_m(q+1,:);
        eta   = eta_m(q+1,:);

        p1 = pow1(q+1,:)*inv_fact(q+1);
        p2 = pow2(q+1,:)*inv_fact(q+1);

        gq = [
            beta0 .* p1;
            alph0 .* p2;
            (f .* beta1 - 1i*m1*fD .* sigma) .* p1;
            (f1 .* beta1 - 1i*m1*f1Der .* sigma) .* p1;
            (f .* alph1 - 1i*m1*fD .* eta) .* p2;
            (f1 .* alph1 - 1i*m1*f1Der .* eta) .* p2
        ];

        cq = ifft(gq, [], 2);

        integrals(1,q,m1i,:) = cq(1,k_idx);
        integrals(2,q,m1i,:) = cq(2,k_idx);
        integrals(3,q,m1i,:) = cq(3,k_idx);
        integrals(4,q+1,m1i,:) = cq(4,k_idx);
        integrals(5,q,m1i,:) = cq(5,k_idx);
        integrals(6,q+1,m1i,:) = cq(6,k_idx);

    end

    %% q = P

    beta0 = beta_m(P+1,:);
    alph0 = alph_m(P+1,:);

    beta1 = beta_m(P+2,:);
    alph1 = alph_m(P+2,:);

    sigma = sigma_m(P+1,:);
    eta   = eta_m(P+1,:);

    p1 = pow1(P+1,:)*inv_fact(P+1);
    p2 = pow2(P+1,:)*inv_fact(P+1);

    gqP = [
        beta0 .* p1;
        alph0 .* p2;
        (f .* beta1 - 1i*m1*fD .* sigma) .* p1;
        (f .* alph1 - 1i*m1*fD .* eta) .* p2
    ];

    cP = ifft(gqP, [], 2);

    integrals(1,P,m1i,:) = cP(1,k_idx);
    integrals(2,P,m1i,:) = cP(2,k_idx);
    integrals(3,P,m1i,:) = cP(3,k_idx);
    integrals(5,P,m1i,:) = cP(4,k_idx);

end

%% scattering matrix update

new_scat_matrix = zeros(size(obj.genScatMat));

surface = n1*r0*(f+f1);

inc_field_surf = zeros(1,p);
der_inc_field_surf = zeros(1,p);

for mi = 1:Nm

    m = m_vec(mi);

    exponent = Epos(mi,:);
    bes = besselj(m,surface);

    inc_field_surf = inc_field_surf - inc_coeffs(mi)*exponent.*bes;

    der_inc_field_surf = der_inc_field_surf - inc_coeffs(mi).*exponent.* ...
        ((f+f1).*0.5.*(besselj(m-1,surface)-besselj(m+1,surface)) ...
        -1i*m*(fD+f1Der).*bes./surface);
end

st0_coeffs = zeros(1,2*Nm);

for mi=1:Nm

    i1 = inc_field_surf .* Eneg(mi,:);
    i2 = der_inc_field_surf .* Eneg(mi,:);

    st0_coeffs(mi)     = sum(i1)*dphi/(2*pi);
    st0_coeffs(mi+Nm)  = sum(i2)*dphi/(2*pi);

end

%% main perturbation loop

for col = 1:2*Nm

    pseudo_stl = zeros(2*Nm,1);
    pseudo_stl(col) = 1;

    coeffs = obj.genScatMat * pseudo_stl;

    sca_coeffs(1,:) = coeffs(1:Nm);
    int_coeffs(1,:) = coeffs(Nm+1:end);

    for pstep = 1:P

        stl_temp = zeros(1,2*Nm);

        for m1 = 1:Nm
        for m2 = 1:Nm
        for q = 0:pstep-1

            stl_temp(m2) = stl_temp(m2) ...
                - (sca_coeffs(q+1,m1)*integrals(1,pstep-q,m1,m2) ...
                - int_coeffs(q+1,m1)*integrals(2,pstep-q,m1,m2));

            stl_temp(m2+Nm) = stl_temp(m2+Nm) ...
                - (sca_coeffs(q+1,m1)* ...
                (integrals(3,pstep-q,m1,m2)+integrals(4,pstep-q,m1,m2)) ...
                - int_coeffs(q+1,m1)*n2* ...
                (integrals(5,pstep-q,m1,m2)+integrals(6,pstep-q,m1,m2)));

        end
        end
        end

        coeffs = obj.genScatMat * stl_temp.';

        sca_coeffs(pstep+1,:) = coeffs(1:Nm);
        int_coeffs(pstep+1,:) = coeffs(Nm+1:end);

    end

    sca_sum = sum(sca_coeffs,1);
    int_sum = sum(int_coeffs,1);

    new_scat_matrix(1:Nm,col) = sca_sum;
    new_scat_matrix(Nm+1:end,col) = int_sum;

end

obj.genScatMat = new_scat_matrix;

coeffs = obj.genScatMat * st0_coeffs.';

obj.scaCoeffs = coeffs(1:Nm);
obj.intCoeffs = coeffs(Nm+1:end);

end
