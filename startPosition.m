function points = startPosition(N, R)
    
    phi = (sqrt(5)-1)/2;
    alpha = 2*pi*phi;
    
    k = (1:N)';
    theta = k * alpha;
    r = sqrt(k / N);
    
    points = cell(N, 1);
    for i = 1:N
        points{i} = sqrt(N) * R * [r(i) * cos(theta(i)); r(i) * sin(theta(i))];
    end
    
    return 
coordinates = cell(1, N);
if N == 16
    coordinates{1} = [0; R];
else
    coordinates{1} = [0; 0];
end

direction = [R; 0];
rotation = [[0 1]; [-1 0]];
length = 1;

particlesLeft = N-1;
iter = true;
while particlesLeft > 0
    for k = 1:length
        coordinates{N - particlesLeft + 1} = coordinates{N - particlesLeft} + direction;
        particlesLeft = particlesLeft - 1;
        if particlesLeft == 0
            break;
        end
    end
    direction = rotation * direction;
    if iter
        iter = false;
    else
        iter = true;
        length = length + 1;
    end
end
end