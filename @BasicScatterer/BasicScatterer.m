classdef BasicScatterer < handle
    
    properties
        sizeParam double = 1.0;
        refrIndexOut double = 1.0;
        maxHarmNum = 1;
        scaMatrix double = [];
        
        scaCoeffs double = [];
        intMatrix double = [];
        incCoeffs double = [];
        intCoeffs double = [];
    end
    
    methods
        
        function obj = BasicScatterer(varargin)
            
            for i = 1:2:length(varargin)
                
                if i + 1 <= length(varargin)
                    
                    switch lower(varargin{i})
                        case 'sizeparam'
                            obj.sizeParam = varargin{i + 1};
                        case 'refrindexout'
                            obj.refrIndexOut = varargin{i + 1};
                        case 'maxharmnum'
                            obj.maxHarmNum = round(varargin{i + 1});
                    end
                    
                end
                
            end
            
            obj.scaMatrix = zeros(2 * obj.maxHarmNum + 1);
            obj.intMatrix = zeros(2 * obj.maxHarmNum + 1);
            obj.scaCoeffs = zeros(2 * obj.maxHarmNum + 1, 1);
            obj.incCoeffs = zeros(2 * obj.maxHarmNum + 1, 1);
            obj.intCoeffs = zeros(2 * obj.maxHarmNum + 1, 1);
            
        end
        
        obj = SetIncField(obj, type, coeffs);
        ax = FarFieldPlot(obj, parentAx);
        sigma = CrossSection(obj, direction, width);
        
    end
    
end
