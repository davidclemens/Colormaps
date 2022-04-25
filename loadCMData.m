function [data,validMaps,validTypes,validLibraries] = loadCMData
% loadCMData  Load colormap data
%   LOADCMDATA loads colormap data into workspace
%
%   Syntax
%     data = LOADCMDATA
%     [data,validMaps,validTypes,validLibraries] = LOADCMDATA
%
%   Description
%     data = LOADCMDATA loads colormap data into workspace
%     [data,validMaps,validTypes,validLibraries] = LOADCMDATA additionally
%       returns valid colormap names, types and library names.
%
%   Example(s)
%     data = LOADCMDATA
%
%
%   Input Arguments
%
%
%   Output Arguments
%     data - colormap data
%       struct
%         Colormap data returned as a struct with metadata and the actual
%         colormap data of the dataset.
%
%     validMaps - valid colormap names
%       cellstr
%         List of valid colormap names contained in the dataset.
%
%     validTypes - valid colormap types
%       cellstr
%         List of valid colormap types contained in the dataset.
%
%     validLibraries - valid colormap library names
%       cellstr
%         List of valid colormap library names contained in the dataset.
%
%
%   Name-Value Pair Arguments
%
%
%   See also CM
%
%   Copyright (c) 2022-2022 David Clemens (dclemens@geomar.de)
%

    % Load raw data
    data = load([fileparts(mfilename('fullpath')),'/cmData.mat'],'cmData');
    data = data.cmData;
    
    % Set valid inputs
    validMaps       = {data.Name};
    validTypes      = unique({data.Type});
    validLibraries  = unique({data.Library});
end
