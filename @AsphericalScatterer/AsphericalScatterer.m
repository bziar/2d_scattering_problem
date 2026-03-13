classdef AsphericalScatterer < SphericalScatterer
    
    properties
        % border SphericalBorder;
        
        % sizeParam double = 1.0;
        % refrIndexOut double = 1.0;
        % refrIndexIn double = 1.5;
        % maxHarmNum int = 1;
        % scaMatrix double = [];
        % intMatrix double = [];
        
        % scaCoeffs double = [];
        % incCoeffs double = [];
        % intCoeffs double = [];
        
        maxShapeCoeffsNum double = 1;
        maxPertStep double = 1;
        shapeGridSize double = 1024;
        
        shapeCoeffs double = [];
        newShapeCoeffs double = [];
        shape double = [];
        shDer double = [];
        
        shapeDecompMat double = [];
        genScatMat double = [];

        gradients cell;
        
        % condViolation double = 0;
    end
    
    methods
        
        function obj = AsphericalScatterer(varargin)
            
            obj@SphericalScatterer(varargin{:});
            
            for i = 1:2:length(varargin)
                
                if i + 1 <= length(varargin)
                    
                    switch lower(varargin{i})
                        case 'maxshapecoeffsnum'
                            obj.maxShapeCoeffsNum = varargin{i + 1};
                        case 'maxpertstep'
                            obj.maxPertStep = varargin{i + 1};
                        case 'shapegridsize'
                            obj.shapeGridSize = varargin{i + 1};
                    end
                    
                end
                
            end
            
            obj.shapeCoeffs = zeros(1, 2*obj.maxShapeCoeffsNum);
            obj.shape = ones(1, obj.shapeGridSize);
            obj.shDer = zeros(1, obj.shapeGridSize);
        end
        
        % obj = SetIncField(obj, type, coeffs);
        % ax = FarFieldPlot(obj, parentAx);
        % sigma = CrossSection(obj, direction, width);
        
        function obj = ShapeUpdate(obj, coeffs)
            if nargin == 2
                obj.maxShapeCoeffsNum = numel(coeffs) / 2;
                obj.shapeCoeffs = coeffs;
            end
            phiArr = linspace(0, 2*pi, obj.shapeGridSize + 1);
            phiArr = phiArr(1:end-1);
            [obj.shape, obj.shDer] = obj.ShapeCalc(phiArr);
        end
        
        function [s, sD] = ShapeCalc(obj, phiArr)
            s = ones(1, numel(phiArr));
            sD = zeros(1, numel(phiArr));
            for k = 1:obj.maxShapeCoeffsNum
                s = s + obj.shapeCoeffs(2*k-1) * sin(k * phiArr) + obj.shapeCoeffs(2*k) * cos(k * phiArr);
                sD = sD + k * (obj.shapeCoeffs(2*k-1) * cos(k * phiArr) - obj.shapeCoeffs(2*k) * sin(k * phiArr));
            end
        end
        
        ax = ShapePlot(obj, parentAx);
        obj = EBCM(obj);
        obj = oldEBCM(obj);
        obj = CheckCondition(obj, show);
        
        function obj = CutMatrix(obj, mNew)
            delta = obj.maxHarmNum - mNew;
            obj.scaMatrix = obj.scaMatrix(1 + delta : end - delta, 1 + delta : end - delta);
            obj.intMatrix = obj.intMatrix(1 + delta : end - delta, 1 + delta : end - delta);
            obj.maxHarmNum = mNew;
            obj.incCoeffs = obj.incCoeffs(1 + delta : end - delta);
            obj.intCoeffs = obj.intMatrix * obj.incCoeffs;
            obj.scaCoeffs = obj.scaMatrix * obj.incCoeffs;
        end

        function obj = ShapeDecomposition(obj)
            M = obj.maxHarmNum;
            Nm = 2*M + 1;
            p = obj.shapeGridSize;
            phiArr = linspace(0, 2*pi, p + 1);
            phiArr = phiArr(1:end-1);

            n1 = obj.refrIndexOut;
            r0 = obj.sizeParam;
            f = obj.shape;
            fD = obj.shDer;
            surface = n1 * r0 * f;

            m_vec = -M:M;

            Mup = zeros(Nm, Nm);
            Mdown = zeros(Nm, Nm);

            for mi = 1:Nm
                m = m_vec(mi);
                bes = besselj(m, surface);

                inc_term = -bes;
                der_term = -n1 * (f .* 0.5 .* (besselj(m - 1, surface) - besselj(m + 1, surface)) ...
                    - 1i * m * fD .* bes ./ surface);

                c1 = ifft(inc_term);
                c2 = ifft(der_term);

                k_idx = mod(m - m_vec, p) + 1;
                Mup(:, mi) = c1(k_idx);
                Mdown(:, mi) = c2(k_idx);
            end

            obj.shapeDecompMat = [Mup; Mdown];
        end
        
        function obj = Init(obj)
            n1 = obj.refrIndexOut;
            n2 = obj.refrIndexIn;
            q = obj.sizeParam;
            
            M = obj.maxHarmNum;
            mExpand = -(M+2):(M+2);
            
            besseljCashe1 = besselj(mExpand, n1 * q);
            besseljCashe2 = besselj(mExpand, n2 * q);
            besselyCashe1 = bessely(mExpand, n1 * q);
            
            % g = (n2/n1)^2;
            g = 1;
            
            a01 = besseljCashe1(3:end-2);
            a02 = besseljCashe2(3:end-2);
            a11 = 0.5 * n1 * (besseljCashe1(2:end-3) - besseljCashe1(4:end-1));
            a12 = 0.5 * n2 * (besseljCashe2(2:end-3) - besseljCashe2(4:end-1));
            
            b01 = a01 + 1j * besselyCashe1(3:end-2);
            b11 = a11 + 1j * 0.5 * n1 * (besselyCashe1(2:end-3) - besselyCashe1(4:end-1));
            den = -(g * a02 .* b11 - a12 .* b01);

            AS = +diag(a12 ./ den);
            AT = -diag(a02 ./ den);
            BS = +diag(b11 ./ den);
            BT = -diag(b01 ./ den);

            obj.genScatMat = [AS, AT; BS, BT];
            obj.ShapeDecomposition();
            obj.scaMatrix = obj.genScatMat(1:2*M+1, :) * obj.shapeDecompMat;
            obj.intMatrix = obj.genScatMat(2*M+2:end, :) * obj.shapeDecompMat;
        end


        obj = SetShape(obj, type);
        obj = functionCalc(obj);
        obj = PerturbStep(obj, f1Coeffs);
        obj = PerturbFull(obj, f1Coeffs, nSteps);
        obj = GradientCalc(obj);

        
    end
    
end
