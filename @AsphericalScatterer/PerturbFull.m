function obj = PerturbFull(obj, f1Coeffs, nSteps)
    for n = 1:nSteps
        % fprintf("Step %d / %d\n", n, nSteps);
        obj.genScatMat = obj.PerturbStep(f1Coeffs / nSteps);
        obj.ShapeUpdate(obj.shapeCoeffs + f1Coeffs / nSteps);
    end
    obj.ShapeDecomposition();
    obj.scaMatrix = obj.genScatMat(1:2*obj.maxHarmNum+1, :) * obj.shapeDecompMat;
    obj.intMatrix = obj.genScatMat(2*obj.maxHarmNum+2:end, :) * obj.shapeDecompMat;
    obj.scaCoeffs = obj.scaMatrix * obj.incCoeffs;
    obj.intCoeffs = obj.intMatrix * obj.incCoeffs;

    % obj.ShapePlot();
    % obj.FarFieldPlot();
end