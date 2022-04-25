function varargout = showGallery(varargin)
% showGallery  Show a gallery of colormaps
%   SHOWGALLERY creates a figure which shows a gallery of all colormaps.
%
%   Syntax
%     SHOWGALLERY
%     SHOWGALLERY(type)
%     SHOWGALLERY(type,library)
%     f = SHOWGALLERY(__)
%
%   Description
%     SHOWGALLERY shows a gallery of all colormaps
%     SHOWGALLERY(type) shows a gallery of all colormaps of type type
%     SHOWGALLERY(type,library) shows a gallery of all colormaps of type type
%       and library library.
%     f = SHOWGALLERY(__) additionally returns the figure handle
%
%   Example(s)
%     SHOWGALLERY
%     SHOWGALLERY(~,'cbrewer')
%     SHOWGALLERY('diverging')
%     SHOWGALLERY('cyclic','cmocean')
%
%
%   Input Arguments
%     type - colormap type
%       '' (default) | 'sequential' | 'diverging' | 'cyclic' |
%       'multi-sequential' | 'qualitative'
%         Filter the colormaps to show by colormap type. All colormaps are shown
%         by default (''). If both type and library are supplied, they are
%         combined by the logical AND operator.
%
%     library - colormap library name
%       '' (default) | 'cbrewer' | 'cmocean' | 'crameri'
%         Filter the colormaps to show by colormap library. All colormaps are 
%         shown by default (''). If both library abd type are supplied, they are
%         combined by the logical AND operator.
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
    
    narginchk(0,2)
    nargoutchk(0,1)
    
    % Load raw data
    [colormapData,~,validTypes,validLibraries] = loadCMData;
    validTypes      = cat(2,validTypes,{''}); % Append 'no type specified'
    validLibraries  = cat(2,validLibraries,{''}); % Append 'no library specified'
    colormapData    = struct2table(colormapData);
    nMapsTotal      = size(colormapData,1);
    
    % Set defaults
    type    = '';
    library = '';
    
    % Input check
    if nargin == 1
        type = varargin{1};
    elseif nargin == 2
        type    = varargin{1};
        library = varargin{2};
    end
    type	= validatestring(type,validTypes,mfilename,'type',1);
    library	= validatestring(library,validLibraries,mfilename,'library',2);
    
    % Find the colormaps that should be shown
    mask    = true(nMapsTotal,1);
    if ~isempty(type)
        mask    = mask & strcmp(colormapData{:,'Type'},type);
    end
    if ~isempty(library)
        mask    = mask & strcmp(colormapData{:,'Library'},library);
    end
    
    nMaps   = sum(mask);
    maps    = sortrows(colormapData(mask,:),{'Type','Library','Name'});

    nLevels = [64,11];
    
    marginAxes      = [15 15 15 50]; % Pixel (left,bottom,right,top)
    
    hr              = groot();
    widthFigure     = hr.ScreenSize(3)/2;
    heightFigure    = hr.ScreenSize(4) - 50;
    originXFigure   = 0;
    originYFigure   = 0;
    
    widthAxes       = widthFigure - sum(marginAxes([1,3]));
    heightAxes      = heightFigure - sum(marginAxes([2,4]));
    originXAxes     = marginAxes(1);
    originYAxes     = marginAxes(2);
    
    heightBar       = 40; % Pixel
    marginBar       = [5 30]; % Pixel (X,Y)
    nYBars          = floor(heightAxes/(heightBar + marginBar(2)));
    nXBars          = ceil(nMaps/nYBars);
    widthBar        = (widthAxes - (nXBars - 1)*marginBar(1))/nXBars;
    originXBar      = (0:(nXBars - 1)).*(marginBar(1) + widthBar);
    originYBar      = ((nYBars - 1):-1:0).*(marginBar(2) + heightBar);
    barI            = reshape((1:nXBars*nYBars)',nYBars,nXBars);
    noData          = false(size(barI));
    noData(nMaps + 1:end) = true;
    
    % Initialize figure and axes
    f = figure(5);
    clf(f);
    set(f,...
        'menubar',   	'none',...
        'numbertitle',	'off',...
        'Name',       	'colormap gallery',...
        'Color',        0.5.*ones(1,3),...
        'Units',        'pixels',...
        'Position',     [originXFigure,originYFigure,widthFigure,heightFigure]);
    
    hax = axes(...
        'NextPlot',     'add',...
        'Units',        'pixels',...
        'Position',     [originXAxes,originYAxes,widthAxes,heightAxes],...
        'XColor',       'none',...
        'YColor',       'none',...
        'Color',        'none',...
        'XLim',         [0 widthAxes],...
        'YLim',         [0 heightAxes]);
    
    warning('Off','Colormaps:cm:NoInterpolationForQualitativeColormaps')
  	for ll = 1:numel(nLevels)
        % X data points for color patches
        xData	= repmat(linspace(0,widthBar,nLevels(ll) + 1),4,1);
        xData(2:3,1:end - 1) = xData(2:3,2:end);
        xData   = xData(:,1:end - 1);
        
        % Y data points for color patches
        yData   = heightBar.*([zeros(2,nLevels(ll));ones(2,nLevels(ll))])./numel(nLevels) ...
                  + heightBar.*((ll - 1)./numel(nLevels));
        for col = 1:nXBars
            X   = originXBar(col) + xData; % Offset to correct column
            for row = 1:nYBars
                Y	= originYBar(row) + yData; % Offset to correct row

                if noData(row,col)
                    continue
                end
                
                % Construct appropriate colormap.
                cData = cm(maps{barI(row,col),'Name'}{:},nLevels(ll));

                % Display colormap chart
                patch(...
                    'XData',            X,...
                    'YData',            Y,...
                    'EdgeColor',        'none',...
                    'FaceColor',        'flat',...
                    'FaceVertexCData',	cData);
            end
        end
    end
    warning('On','Colormaps:cm:NoInterpolationForQualitativeColormaps')
    
    % Add colormap names
    [Y,X] = ndgrid(originYBar,originXBar);
    text(hax,X(~noData),Y(~noData) + heightBar,...
        strcat(maps{barI(~noData),'Name'},{' ('},maps{barI(~noData),'Type'},{', '},maps{barI(~noData),'Library'},{')'}),...
        'VerticalAlignment',    'bottom',...
        'FontSize',             12,...
        'Color',                'w');
    
    % Add title
    text(hax,marginBar(1),heightAxes,...
        'Colormaps',...
        'VerticalAlignment',    'baseline',...
        'FontSize',             36,...
        'Color',                'w');
    
    if nargout == 1
        varargout{1} = f;
    end
end
