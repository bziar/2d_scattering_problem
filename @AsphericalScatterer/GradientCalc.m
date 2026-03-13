function obj = GradientCalc(obj)
    oldShapeCoeffs = obj.shapeCoeffs;
    oldShapeDecompMat = obj.shapeDecompMat;
    delta = 1e-3;
    for s = 1:4
        coeffs = [zeros(1, 8)];
        coeffs(4 + s) = delta;
        obj.ShapeUpdate(oldShapeCoeffs + coeffs);
        obj.ShapeDecomposition();
        genMatGrad = (obj.PerturbStep(coeffs) - obj.genScatMat) * obj.shapeDecompMat;
        obj.gradients{s} = genMatGrad(1:2*obj.maxHarmNum+1, :) / delta;
    end
    obj.shapeCoeffs = oldShapeCoeffs;
    obj.shapeDecompMat = oldShapeDecompMat;
end