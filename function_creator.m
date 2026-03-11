function function_creator(phi_arr, alpha)
    global PARAMS;
    
    if nargin < 2
      alpha = 0;
    end

    PARAMS.f0_arr = zeros(size(phi_arr));
    PARAMS.f1_arr = zeros(size(phi_arr));
    PARAMS.f0_der_arr = zeros(size(phi_arr));
    PARAMS.f1_der_arr = zeros(size(phi_arr));
    
    for m = 0:(PARAMS.F / 2 - 1)
        PARAMS.f0_arr = PARAMS.f0_arr + PARAMS.f0_coeffs(2*m + 1) * sin(m * phi_arr);
        PARAMS.f0_arr = PARAMS.f0_arr + PARAMS.f0_coeffs(2*m + 2) * cos(m * phi_arr);
    
        PARAMS.f1_arr = PARAMS.f1_arr + PARAMS.f1_coeffs(2*m + 1) * sin(m * phi_arr);
        PARAMS.f1_arr = PARAMS.f1_arr + PARAMS.f1_coeffs(2*m + 2) * cos(m * phi_arr);
    
        PARAMS.f0_der_arr = PARAMS.f0_der_arr + m * PARAMS.f0_coeffs(2*m + 1) * cos(m * phi_arr);
        PARAMS.f0_der_arr = PARAMS.f0_der_arr - m * PARAMS.f0_coeffs(2*m + 2) * sin(m * phi_arr);
        
        PARAMS.f1_der_arr = PARAMS.f1_der_arr + m * PARAMS.f1_coeffs(2*m + 1) * cos(m * phi_arr);
        PARAMS.f1_der_arr = PARAMS.f1_der_arr - m * PARAMS.f1_coeffs(2*m + 2) * sin(m * phi_arr);
    end
    
    PARAMS.f_arr = PARAMS.f0_arr + PARAMS.f1_arr;
    PARAMS.f_der_arr = PARAMS.f0_der_arr + PARAMS.f1_der_arr;
end

