function plotGeometry(SYSTEM, params)
figure;

nRad = SYSTEM.N-SYSTEM.N_asph;
radii = SYSTEM.r * (1 + params(1:nRad));
shifts = SYSTEM.r * params(nRad+1:nRad+2*SYSTEM.N);
shape_params = params(nRad+2*SYSTEM.N+1:end);

nAsph = 1;
nSph = 1;
for i=1:SYSTEM.N
    
    x0 = SYSTEM.coordinates{i}(1) + shifts(2*i-1) * SYSTEM.r;
    y0 = SYSTEM.coordinates{i}(2) + shifts(2*i) * SYSTEM.r;

    if SYSTEM.types(i) == 1
        tArr = linspace(0, 2*pi, 100);
        
        [s, ~] = SYSTEM.particles{nAsph}.ShapeCalc(tArr);
        
        xArr = x0 + SYSTEM.particles{nAsph}.sizeParam * s .* cos(tArr);
        yArr = y0 + SYSTEM.particles{nAsph}.sizeParam * s .* sin(tArr);
        
        plot(xArr, -yArr, 'Color', 'red');
        hold on
        nAsph = nAsph + 1;
    else

        R = SYSTEM.r * (1 + radii(nSph));
        tArr = linspace(0, 2*pi, 100);
        xArr = x0 + R * cos(tArr);
        yArr = y0 + R * sin(tArr);
        plot(xArr, -yArr, 'Color', 'red');
        hold on
        nSph = nSph + 1;
    end
end
axis equal
end