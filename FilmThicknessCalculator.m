classdef FilmThicknessCalculator < handle
    properties
        
        plotflag = false;
        saveflag = true;
        
        config = containers.Map();
        
    end;
    methods
        
        %% Constructor
        function obj = FilmThicknessCalculator(a,b)
            if( nargin == 1)
                % two possibilities:
                % 1. just a config file (char array)
                if( ischar(a))
                    obj.readConfigFile(a);
                    
                % 2. Otherwise, a containers.map
                elseif( class( b ) == 'containers.Map' )
                    obj.readConfigMap(a);
                else
                    error('Error. \nInput must be a valid file or map');
                end;
            elseif( nargin == 2)
                % two inputs:
                % use the file as global setting,
                % and map for specific settings.
                try
                    obj.readConfigFile(a);
                    obj.readConfigMap(b);
                catch ME
                    error('Error. \nInput must be a valid file or map');
                    rethrow(ME);
                end;
            else
                % otherwise, just use default config.
                obj.defaultConfig();
            end;
        end;    %% end of constructor function %%
        
        %%%%%%%%%%%%%%%%%%%%%
        % Utility functions %
        %%%%%%%%%%%%%%%%%%%%%
        
        %% Read and save configurations from file.
        function readConfigFile( obj, filelocation )
            obj.defaultConfig();
            try
                thefile = fopen('filelocation');
                tline = fgets(thefile);
                while ischar(tline)
                    tlineString = string(tline);
                    lineSet = split(tline,'=');
                    obj.config( strtrim(lineSet(1)) ) = strtrim(lineSet(2));
                end;
                
            catch ME
                disp('Error. \nInput must be a valid file or struct');
                rethrow(ME);
            end;
            
        end;
        
        %% Set the default configurations.
        function defaultConfig( obj )
            configMapKeys = {'plotflag', 'saveflag', 'pixSize', 'refIndexFluid','refIndexWall','dryDiameter','dryStdErr','thicknessWall','dataFile','saveFile'};
            configMapValues = {false, true, 25.8042, 1.26 ,1.517, 418.4232, 0.3087, 3200, './samples/sample.tiff', '~/Desktop/test.mat'};
            obj.config = containers.Map(configMapKeys, configMapValues);
        end;
        
        %% Pre Process Variables
        function preProcess( obj )
            
            % Determine the critical angle
            obj.config('critAngle') = obj.criticalAngle( obj.config('refIndexFluid') );
            
            % TODO: determine what kind of image we are processing, and how
            % many?
            % ...
            
            
        end;
        
        %% Process data - batch
        function process( obj )
            
            % set all necessary variable pre process
            obj.preProcess();
            
            % progress bar
            wBar = waitbar(0,'Processing Images...', 'Name', 'Processing Images...','CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
            setappdata(wBar,'canceling',0)
            
            % parallel for-loop
            parfor n = 1 : obj.config( 'numImages' )
                obj.processParfor( obj );
            end;
        end;
         
        %% Process data - Parfor
        function processParfor( obj )
            
            
        end;
    end;
    
    methods (Static)
        
        function critAngle = criticalAngle(RefInd)
            
            if RefInd <= 0
                critAngle = 1;
            else
                critAngle = asin(1/RefInd);
            end;
            
        end;
    end;
end