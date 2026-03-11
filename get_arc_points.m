function points = get_arc_points(A, B, C, N)
    A = A(:)'; B = B(:)'; C = C(:)';
    
    D = 2*(A(1)*(B(2)-C(2)) + B(1)*(C(2)-A(2)) + C(1)*(A(2)-B(2)));
    if abs(D) < 1e-10; error('Точки коллинеарны'); end
    
    Ux = ((A(1)^2+A(2)^2)*(B(2)-C(2)) + (B(1)^2+B(2)^2)*(C(2)-A(2)) + (C(1)^2+C(2)^2)*(A(2)-B(2))) / D;
    Uy = ((A(1)^2+A(2)^2)*(C(1)-B(1)) + (B(1)^2+B(2)^2)*(A(1)-C(1)) + (C(1)^2+C(2)^2)*(B(1)-A(1))) / D;
    center = [Ux, Uy];
    radius = norm(A - center);
    
    theta = @(p) atan2(p(2)-center(2), p(1)-center(1));
    thA = theta(A); thC = theta(C);
    
    if thC < thA; thC = thC + 2*pi; end
    
    th = linspace(thA, thC, N+2);
    points = center + radius * [cos(th(2:end-1)'), sin(th(2:end-1)')];
end
 