classdef MultiSystem < BasicScatterer
    
    properties
        % sizeParam double = 1.0;
        % refrIndexOut double = 1.0;
        maxHarmNum1 = 1;
        % scaMatrix double = [];
        
        % scaCoeffs double = [];
        % incCoeffs double = [];
        
        numParticles = 1;
        coordinates = {};
        angles = {};
        scaMatrices = {};
        % transMatrices = {};
        Q = [];
        targetFunc = 0;
        radii = {};
        scaMatrices_der = {};
        scaMatrix_der = {};
        allCoefs = [];

        numP;
    end
    
    methods
        
        function obj = MultiSystem(varargin)
            
            obj@BasicScatterer(varargin{:});
            
            for i = 1:2:length(varargin)
                
                if i + 1 <= length(varargin)
                    
                    switch lower(varargin{i})
                        case 'numparticles'
                            obj.numParticles = varargin{i + 1};
                        case 'maxharmnum1'
                            obj.maxHarmNum1 = varargin{i + 1};
                        case 'coordinates'
                            obj.coordinates = varargin{i + 1};
                        case 'angles'
                            obj.angles = varargin{i + 1};
                        case 'scamatrices'
                            obj.scaMatrices = varargin{i + 1};
                        case 'scamatrices_der'
                            obj.scaMatrices_der = varargin{i + 1};
                    end
                    
                end
                
            end
            
        end
        
        obj = Calculate(obj);
        obj = Calculate2(obj);
        obj = Calculate3(obj);
        obj = Calculate4(obj);
        obj = CalcIterative(obj, numSteps);
        obj = MultiFarField(obj, parentAx);
        
        % sigma = CrossSection(obj, direction, width);
    end
    
end
