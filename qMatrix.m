function Q = qMatrix(M, direction, width)
p1 = direction - width/2;
p2 = direction + width/2;
Q = zeros(2*M+1);
mArr = (-M:M);
for m = mArr
    n = mArr;
    vec = (exp(1j*(m-n)*p2) - exp(1j*(m-n)*p1)) ./ (2*pi*1j*(m-n));
    vec(m+M+1) = p2 - p1;
    Q(m+M+1, :) = vec;
end

% M2 = M + 10;
% N_phi_mesh = 8000;
% phi_mesh = linspace(0, 2*pi, N_phi_mesh + 1);
% phi_mesh = phi_mesh(1:end-1);
% dphi = phi_mesh(2) - phi_mesh(1);

% q_matrix_2d = zeros(1 + 2*M, 1 + 2*M2);

% for m1 = -M:M
%     % clc
%     % disp(m1)
%     cut_harm = exp(1j * (m1 * phi_mesh - m1 * pi / 2 - pi / 4)) .* window(phi_mesh, direction, width, pi/360);
%     cut_harm(isnan(cut_harm)) = 0;

%     for m2 = -M2:M2
%         q_matrix_2d(m1 + 1 + M, m2 + 1 + M2) = (1 / 2 / pi * sum(dphi * cut_harm .* exp(-1j * m2 * phi_mesh)));
%     end
% end
% % save('q_matrix_2d.mat', 'q_matrix_2d')
% % q = q_matrix_2d;

%     function y = window(theta, alpha, delta, dphi)
%         % Плавная ступенька с использованием функции ошибки
%         %
%         % Входные параметры:
%         %   dphi - характерная ширина спада (стандартное отклонение)
%         theta_norm = mod(theta, 2*pi);
%         alpha_norm = mod(alpha, 2*pi);

%         diff = abs(theta_norm - alpha_norm);
%         angular_distance = min(diff, 2*pi - diff);

%         x = (delta/2 - angular_distance) / (sqrt(2) * dphi);
%         y = 0.5 + 0.5 * erf(x);
%     end

end