M = 40;
N = 2;
r0 = 5;
close all;


n_out = 1;
dr = 1e-12;
ind = 1;

for r = [r0 + dr, r0, r0 - dr]
    test = SphericalScatterer(...
        'sizeParam', r, ...
        'refrIndexOut', n_out, ...
        'refrIndexIn', 2, ...
        'maxHarmNum', M);
    test.Calculate();
    
    test0 = SphericalScatterer(...
        'sizeParam', 1.5*r0, ...
        'refrIndexOut', n_out, ...
        'refrIndexIn', 2, ...
        'maxHarmNum', M);
    test0.Calculate();
    
    angles = cell(1, N);
    scaMatrices = cell(1, N);
    scaMatrices_der = cell(1, N);
    
    for k = 1:N
        scaMatrices{k} = test.scaMatrix;
        scaMatrices_der{k} = test.scaMatrix_der;
        angles{k} = 0;
    end
    scaMatrices = {test.scaMatrix, test0.scaMatrix};
    scaMatrices_der = {test0.scaMatrix_der, test0.scaMatrix_der};
    R = 3 * r0;
    coords =  startPosition(N, R);
    
    % coords = {[0; -R/2], [0; R/2;], [R; R/2]};
    mTest = MultiSystem(...
        'sizeParam', sqrt(N) * r0, ...
        'refrIndexOut', n_out, ...
        'maxHarmNum', M, ...
        'numParticles', N, ...
        'coordinates', coords, ...
        'angles', angles, ...
        'scaMatrices', scaMatrices, ...
        'scaMatrices_der', scaMatrices_der);
    mTest.CalcIterative(30);
    
    switch (ind)
        case 1
            scaDer1 = mTest.scaMatrix;
        case 2
            mTest.Calculate();
            scaDer0 = mTest.scaMatrix_der{1};
            mTest.SetIncField('planewave');
            mTest.FarFieldPlot();
        case 3
            scaDer1 = (scaDer1 - mTest.scaMatrix) / 2 / dr;
    end
    
    ind = ind + 1;
end
figure;
plot(abs(scaDer1(:) - scaDer0(:)));

