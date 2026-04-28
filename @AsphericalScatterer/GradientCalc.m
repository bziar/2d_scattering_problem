function obj = GradientCalc(obj)
    oldShapeCoeffs = obj.shapeCoeffs;
    oldShapeDecompMat = obj.shapeDecompMat;
    oldShape = obj.shape;
    oldShapeDer = obj.shDer;
    delta = 1e-6;
    for s = 1:4
        coeffs = [zeros(1, 8)];
        coeffs(4 + s) = delta;
        scatMatGrad = (obj.PerturbStep(coeffs) - obj.genScatMat);
        obj.ShapeUpdate(oldShapeCoeffs + coeffs);
        % obj.ShapeDecomposition();
        scatMatGrad = scatMatGrad * obj.shapeDecompMat;
        obj.gradients{s} = scatMatGrad(1:2*obj.maxHarmNum+1, :) / delta;
        % obj.ShapeUpdate(oldShapeCoeffs);
        obj.shape = oldShape;
        obj.shDer = oldShapeDer;
        obj.shapeCoeffs = oldShapeCoeffs;
    end
    obj.shapeDecompMat = oldShapeDecompMat;
end