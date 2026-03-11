function plotGeometry(SYSTEM, params)
figure;
for i=1:SYSTEM.N
    x0 = SYSTEM.coordinates{i}(1);
    y0 = SYSTEM.coordinates{i}(2);
    if i > 1
        x0 = x0 + params(SYSTEM.N + 2*i-3) * SYSTEM.r;
        y0 = y0 + params(SYSTEM.N + 2*i-2) * SYSTEM.r;
    end
    R = SYSTEM.r * (1 + params(i));
    tArr = linspace(0, 2*pi, 100);
    xArr = x0 + R * cos(tArr);
    yArr = y0 + R * sin(tArr);
    plot(xArr, -yArr, 'Color', 'red');
    hold on
end
axis equal
end