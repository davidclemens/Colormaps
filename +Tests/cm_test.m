classdef (SharedTestFixtures = { ...
            matlab.unittest.fixtures.PathFixture(subsref(strsplit(mfilename('fullpath'),'/+'),substruct('{}',{':'})))
        }) cm_test < matlab.unittest.TestCase
    % cm_test  Unittests for cm
    % This class holds the unittests for the cm method.
    %
    % It can be run with runtests('Tests.cm_test').
    %
    %
    % Copyright (c) 2023-2023 David Clemens (dclemens@geomar.de)
    %
    
    properties
        CMaps
    end
    properties (MethodSetupParameter)
        
    end
    properties (TestParameter)
        Target = struct(...
            'Emtpy',    {{'',[]}},...
            'Scalar',   {{'Handles',1}},...
            'Multiple', {{'Handles',1:2}})
        Map = struct(...
            'S',        {'thermal'},...
            'D',        {'vik'},...
            'MS',       {'oleron'},...
            'C',        {'phase'},...
            'Q',        {'Dark2'})
        Levels = struct(...
            'Emtpy',    [],...
            'Small',    3,...
            'Large',    100)
        Pivot = struct(...
            'Empty',    [],...
            'Value',    5)
        Invert = struct(...
            'Empty',    [],...
            'Yes',      true,...
            'No',       false)
    end
    
    methods (TestClassSetup)
        function setupData(testCase)
            testCase.CMaps = loadCMData;
        end
    end
    methods (TestMethodSetup)
        
    end
    methods (TestMethodTeardown)
        
    end
    
    methods (Test)
        function testModeReturnColormap(testCase,Map,Levels,Pivot,Invert)
            
            import matlab.unittest.fixtures.SuppressedWarningsFixture
            
            testCase.applyFixture(...
                SuppressedWarningsFixture('Colormaps:cm:NoInterpolationForQualitativeColormaps'));
            testCase.applyFixture(...
                SuppressedWarningsFixture('Colormaps:cm:PivotForQualitativeColormap'));
            testCase.applyFixture(...
                SuppressedWarningsFixture('Colormaps:cm:PivotForNonDivergingColormap'));
            
            inputs = {Map};
            
            % Get the raw mat data
            indexName  	= ismember({testCase.CMaps.Name},Map)';
            raw         = testCase.CMaps(indexName).Data;
            
            expLevels = 64;
            expFirstRow = raw(1,:);
            
            if ~isempty(Levels)
                inputs = cat(2,inputs,{Levels});
                expLevels = Levels;
            end
            if ~isempty(Invert)
                inputs = cat(2,inputs,{'Invert',Invert});
                if Invert
                    expFirstRow = raw(end,:);
                end
            end
            if ~isempty(Pivot)
                inputs = cat(2,inputs,{'Pivot',Pivot});
            end
            
            act = cm(inputs{:});
            actLevels = size(act,1);
            actFirstRow = act(1,:);
            
            testCase.verifyEqual(actLevels,expLevels)
            
            if isempty(Pivot)
                testCase.verifyEqual(actFirstRow,expFirstRow)
            end
        end
    end
end
