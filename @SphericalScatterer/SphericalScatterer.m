classdef SphericalScatterer < BasicScatterer
    
    properties
        border SphericalBorder;
        
        % sizeParam double = 1.0;
        % refrIndexOut double = 1.0;
        refrIndexIn double = 1.5;
        % maxHarmNum int = 1;
        % scaMatrix double = [];
        % intMatrix double = [];
        
        % scaCoeffs double = [];
        % incCoeffs double = [];
        % intCoeffs double = [];
        
        condViolation double = 0;
        scaMatrix_der double = [];
    end
    
    methods
        
        function obj = SphericalScatterer(varargin)
            
            obj@BasicScatterer(varargin{:});
            
            for i = 1:2:length(varargin)
                
                if i + 1 <= length(varargin)
                    
                    switch lower(varargin{i})
                        case 'refrindexin'
                            obj.refrIndexIn = varargin{i + 1};
                    end
                    
                end
                
            end
            
            % obj.intMatrix = zeros(2 * obj.maxHarmNum + 1);
            % obj.intCoeffs = zeros(2 * obj.maxHarmNum + 1, 1);
            
            obj.border = SphericalBorder(...
                'sizeParam', obj.sizeParam, ...
                'refrIndexOut', obj.refrIndexOut, ...
                'refrIndexIn', obj.refrIndexIn, ...
                'maxHarmNum', obj.maxHarmNum);
            
            obj.Calculate();
            
        end
        
        % obj = SetIncField(obj, type, coeffs);
        % ax = FarFieldPlot(obj, parentAx);
        % sigma = CrossSection(obj, direction, width);
        
        ax = NearFieldPlot(obj, varargin);
        
        function fig = CombinedPlot(obj, varargin)
            fig = figure('Position', [100, 100, 1200, 500]);
            ax1 = subplot(1, 2, 1);
            obj.NearFieldPlot('parent', ax1, varargin{:});
            ax2 = subplot(1, 2, 2);
            obj.FarFieldPlot(ax2);
            sgtitle(fig, ['q = ', num2str(obj.sizeParam), ...
                ', n_{out} = ', num2str(obj.refrIndexOut), ...
                ', M_{max} = ', num2str(obj.maxHarmNum)], ...
                'FontSize', 14, 'FontWeight', 'bold');
        end
        
        function obj = Calculate(obj)
            obj.border.Calculate();
            obj.scaMatrix = diag(obj.border.outerReflection);
            obj.scaMatrix_der = diag(obj.border.outerReflection_der);
            obj.intMatrix = diag(obj.border.innerTransmission);
        end
        
        obj = CheckCondition(obj, show);
        
        % obj = SetIncField(obj, type, coeffs);
        
    end
    
end
