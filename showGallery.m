function varargout = showGallery(varargin)
% showGallery  Show a gallery of colormaps
%   SHOWGALLERY creates a figure which shows a gallery of all colormaps.
%
%   Syntax
%     SHOWGALLERY
%     SHOWGALLERY(library)
%     f = SHOWGALLERY(__)
%
%   Description
%     SHOWGALLERY shows a gallery of all colormaps
%     SHOWGALLERY(library) shows a gallery of all colormaps of library library
%     f = SHOWGALLERY(__) additionally returns the figure handle
%
%   Example(s)
%     SHOWGALLERY
%     SHOWGALLERY('cbrewer')
%
%
%   Input Arguments
%     library - colormap library name
%       'cbrewer' | 'cmocean' | 'crameri'
%         Input1 long description, that can also span multiple lines, since it
%         really goes into detail.
%
%
%   Output Arguments
%     f - target figure
%       figure object
%         Target figure, specified as a Figure object.
%
%
%   Name-Value Pair Arguments
%
%
%   See also CM
%
%   Copyright (c) 2022-2022 David Clemens (dclemens@geomar.de)
%
    
    narginchk(0,1)
    nargoutchk(0,1)
    
    % Load raw data
    [colormapData,~,validTypes,validLibraries] = loadCMData;
    validLibraries  = cat(2,validLibraries,{''}); % Append 'no library specified'
    
    % Input check
    if nargin == 1
        library = varargin{1};
    else
        library = '';
    end
    library	= validatestring(library,validLibraries,mfilename,'Library',1);
    
    f = figure(...
        'menubar',   	'none',...
        'numbertitle',	'off',...
        'Name',       	'colormap gallery',...
        'Color',        0.5.*ones(1,3));
    
    [validTypes,~,indType]      = unique({colormapData.Type});
    [validMaps,~,indMap]        = unique({colormapData.Name});
    [validLibrary,~,indLibrary]	= unique({colormapData.Library});
    nTypes  = numel(validTypes);
    nMaps   = numel(validTypes);
    
    spnx    = nTypes;
    spny    = 1;
    spi     = 1:spnx*spny;
    nLevels = [64,9];
    

    for col = 1:spnx
        hax(col) = axes(...
                	'NextPlot',     'add');
        tt = col;
        for row = 1:spny
            
            for ll = 1:numel(nLevels)
                % X data points for color patches
                xData	= [linspace(0,15,nLevels(ll)); linspace(1,16,nLevels(ll));...
                           linspace(1,16,nLevels(ll)); linspace(0,15,nLevels(ll))];
                offset	= 2*(length(maps) - iMap);
                yData	= [zeros(2, nLevels(ll)); 1.5*ones(2, nLevels(ll))] + offset;

                % Construct appropriate colormap.
                cData = cm(colormapData,nLevels(ll));

                % Display colormap chart
                patch(...
                    'XData',            xData,...
                    'YData',            yData,...
                    'EdgeColor',        'none',...
                    'FaceColor',        'flat',...
                    'FaceVertexCData',	cData)
            end
        end
    end
    
    if nargout == 1
        varargout{1} = f;
    end
end
