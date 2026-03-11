classdef MultiSystem < BasicScatterer
    
    properties
        % sizeParam double = 1.0;
        % refrIndexOut double = 1.0;
        % maxHarmNum = 1;
        % scaMatrix double = [];
        
        % scaCoeffs double = [];
        % incCoeffs double = [];
        
        numParticles = 1;
        coordinates = {};
        shifts = {};
        angles = {};
        scaMatrices = {};
        transMatrices = {};
        params = {};
    end
    
    methods
        
        function obj = MultiSystem(varargin)
            
            obj@BasicScatterer(varargin{:});
            
            for i = 1:2:length(varargin)
                
                if i + 1 <= length(varargin)
                    
                    switch lower(varargin{i})
                        case 'numparticles'
                            obj.numParticles = varargin{i + 1};
                        case 'coordinates'
                            obj.coordinates = varargin{i + 1};
                        case 'angles'
                            obj.angles = varargin{i + 1};
                        case 'scamatrices'
                            obj.scaMatrices = varargin{i + 1};
                    end
                    
                end
                
            end
            

            
        end
        
        obj = Calculate(obj);
        obj = CalcIterative(obj, numSteps);
        
    end
    
end
