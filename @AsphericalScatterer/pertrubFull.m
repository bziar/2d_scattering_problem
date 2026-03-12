function obj = perturbFull(obj, f1Coeffs, nSteps)

    for n = 1:nSteps
        fprintf("Step %d / %d\n", n, nSteps);
        obj.perturbStep(f1Coeffs / nSteps);
        obj.ShapeUpdate(obj.shapeCoeffs + f1Coeffs / nSteps);
    end
    obj.ShapeDecomposition();
    obj.scaMatrix = obj.genScatMat(1:2*obj.maxHarmNum+1, :) * obj.shapeDecompMat;

    obj.ShapePlot();
    obj.FarFieldPlot();

end