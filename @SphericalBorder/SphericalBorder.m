classdef SphericalBorder < handle
    
    properties
        refrIndexOut double = 1.0;
        refrIndexIn double = 1.5;
        sizeParam double = 1;
        maxHarmNum = 1;
        
        transferMatrix double = [];
        outerReflection double = [];
        innerReflection double = [];
        innerTransmission double = [];
        
        outerReflection_der double = [];
    end
    
    methods
        
        function obj = SphericalBorder(varargin)
            
            for i = 1:2:length(varargin)
                
                if i + 1 <= length(varargin)
                    
                    switch lower(varargin{i})
                        case 'sizeparam'
                            obj.sizeParam = varargin{i + 1};
                        case 'refrindexout'
                            obj.refrIndexOut = varargin{i + 1};
                        case 'refrindexin'
                            obj.refrIndexIn = varargin{i + 1};
                        case 'maxharmnum'
                            obj.maxHarmNum = round(varargin{i + 1});
                    end
                    
                end
                
            end
            
            obj.transferMatrix = zeros(2 * (2 * obj.maxHarmNum + 1), 2);
            obj.outerReflection = zeros(2 * obj.maxHarmNum + 1, 1);
            obj.innerReflection = zeros(2 * obj.maxHarmNum + 1, 1);
            obj.innerTransmission = zeros(2 * obj.maxHarmNum + 1, 1);
            
            obj.outerReflection_der = zeros(2 * obj.maxHarmNum + 1, 1);
        end
        
        obj = Calculate(obj);
        
    end
    
end
