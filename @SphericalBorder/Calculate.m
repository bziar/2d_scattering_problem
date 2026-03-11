function obj = Calculate(obj)

m = -obj.maxHarmNum:obj.maxHarmNum;

n1 = obj.refrIndexOut;
n2 = obj.refrIndexIn;
q = obj.sizeParam;

mExpand = (-obj.maxHarmNum - 2):(obj.maxHarmNum + 2);

besseljCashe1 = besselj(mExpand, n1 * q);
besseljCashe2 = besselj(mExpand, n2 * q);
besselyCashe1 = bessely(mExpand, n1 * q);
besselyCashe2 = bessely(mExpand, n2 * q);

% g = (n2/n1)^2;
g = 1;

a01 = besseljCashe1(3:end-2);
a02 = besseljCashe2(3:end-2);
a11 = 0.5 * n1 * (besseljCashe1(2:end-3) - besseljCashe1(4:end-1));
a12 = 0.5 * n2 * (besseljCashe2(2:end-3) - besseljCashe2(4:end-1));
a21 = 0.25 * n1^2 * (besseljCashe1(1:end-4) - 2 * a01 + besseljCashe1(5:end));
a22 = 0.25 * n2^2 * (besseljCashe2(1:end-4) - 2 * a02 + besseljCashe2(5:end));

b01 = a01 + 1j * besselyCashe1(3:end-2);
b02 = a02 + 1j * besselyCashe2(3:end-2);
b11 = a11 + 1j * 0.5 * n1 * (besselyCashe1(2:end-3) - besselyCashe1(4:end-1));
b12 = a12 + 1j * 0.5 * n2 * (besselyCashe2(2:end-3) - besselyCashe2(4:end-1));
b21 = a21 + 1j * 0.25 * n1^2 * (besselyCashe1(1:end-4) - 2 * besselyCashe1(3:end-2) + besselyCashe1(5:end));

den = g * (a01 .* b11 - a11 .* b01); % denominator

T11 = (g * a02 .* b11 - a12 .* b01);
T12 = (b02 .* b11 - b12 .* b01);
T21 = (a12 .* a01 - g * a02 .* a11);
T22 = (b12 .* a01 - b02 .* a11);

T11_der = g * a02 .* b21 - a22 .* b01;
T21_der = a22 .* a01 - g * a02 .* a21;

obj.outerReflection = (T21 ./ T11).';
obj.innerReflection = (T22 ./ T12).';
obj.innerTransmission = (den ./ T11).';

obj.outerReflection_der = obj.outerReflection .* (T21_der ./ T21 - T11_der ./ T11).';

T11 = T11 ./ den;
T12 = T12 ./ den;
T21 = T21 ./ den;
T22 = T22 ./ den;

obj.transferMatrix = [[T11.' T12.']; [T21.' T22.']];

% m = -obj.maxHarmNum:obj.maxHarmNum;

% n1 = obj.refrIndexOut;
% n2 = obj.refrIndexIn;
% q = obj.sizeParam;

% mExpand = [-obj.maxHarmNum - 1, m, obj.maxHarmNum + 1];

% besseljCashe1 = besselj(mExpand, n1 * q);
% besseljCashe2 = besselj(mExpand, n2 * q);
% besselyCashe1 = bessely(mExpand, n1 * q);
% besselyCashe2 = bessely(mExpand, n2 * q);

% a01 = besseljCashe1(2:end-1);
% a02 = besseljCashe2(2:end-1);
% a11 = 0.5 * n1 * (besseljCashe1(1:end-2) - besseljCashe1(3:end));
% a12 = 0.5 * n2 * (besseljCashe2(1:end-2) - besseljCashe2(3:end));

% b01 = a01 + 1j * besselyCashe1(2:end-1);
% b02 = a02 + 1j * besselyCashe2(2:end-1);
% b11 = a11 + 1j * 0.5 * n1 * (besselyCashe1(1:end-2) - besselyCashe1(3:end));
% b12 = a12 + 1j * 0.5 * n2 * (besselyCashe2(1:end-2) - besselyCashe2(3:end));

% den = (a01 .* b11 - a11 .* b01); % denominator

% T11 = (a02 .* b11 - a12 .* b01);
% T12 = (b02 .* b11 - b12 .* b01);
% T21 = (a12 .* a01 - a02 .* a11);
% T22 = (b12 .* a01 - b02 .* a11);

% obj.outerReflection = (T21 ./ T11).';
% obj.innerReflection = (T22 ./ T12).';
% obj.innerTransmission = (den ./ T11).';

% T11 = T11 ./ den;
% T12 = T12 ./ den;
% T21 = T21 ./ den;
% T22 = T22 ./ den;

% obj.transferMatrix = [[T11.' T12.']; [T21.' T22.']];

% %% STABLE CALCULATION

% % mMid = ceil(obj.sizeParam * 1.4);
% % k = obj.maxHarmNum + 15;
% % D = sqrt(obj.maxHarmNum^2 / obj.sizeParam^2 - 1);

% DJ2 = a12 ./ a02;
% DJ1 = a11 ./ a01;
% DH = b11 ./ b01;

% obj.outerReflection = a01 ./ b01 .* (DJ2 - DJ1) ./ (DH - DJ2);

% %%

end