function varargout = cm(varargin)
% cm  Set or create a new colormap
%   CM sets or creates a new colormap from multiple libraries such as
%   'cbrewer', 'cmocean' and 'cameri'.
%
%   Syntax
%     CM
%     CM(map)
%     CM(map,levels)
%     CM(__,Name,Value)
%     cmap = CM(__)
%     __ = CM(target,__)
%
%   Description
%     CM  shows the available colormaps.
%     CM(map) sets the colormap map for the current axes.
%     CM(map,levels) additionally sets the length of the colormap to
%       levels.
%     CM(__,Name,Value) additionally allows for the specification of name-value
%       pair arguments.
%     cmap = CM(__) instead of setting the colormap to the current axes, it is
%       returned as a m-by-3 RGB matrix.
%     __ = CM(target,__) uses the axes specified by target instead of the
%       current axes. Specify target as the first input argument for any of the
%       previous syntaxes.
%
%   Example(s)
%     cmap = CM('tarn')
%     CM('thermal')
%     CM('thermal',15)
%
%
%   Input Arguments
%     map - name of the colormap
%       colormap name
%         Colormap for the new color scheme, specified as a colormap name. A
%         colormap name specifies a predefined colormap with the same number of
%         colors as the current colormap.
%
%            Name     Type                Library
%            ------------------------------------
%            acton    sequential          crameri
%            bam      sequential          crameri
%            bamO     sequential          crameri
%            bamako   sequential          crameri
%            batlow   sequential          crameri
%            batlowK  sequential          crameri
%            batlowW  sequential          crameri
%            berlin   sequential          crameri
%            bilbao   sequential          crameri
%            broc     sequential          crameri
%            brocO    sequential          crameri
%            buda     sequential          crameri
%            bukavu   sequential          crameri
%            cork     sequential          crameri
%            corkO    sequential          crameri
%            davos    sequential          crameri
%            devon    sequential          crameri
%            fes      sequential          crameri
%            grayC    sequential          crameri
%            hawaii   sequential          crameri
%            imola    sequential          crameri
%            lajolla  sequential          crameri
%            lapaz    sequential          crameri
%            lisbon   sequential          crameri
%            nuuk     sequential          crameri
%            oleron   sequential          crameri
%            oslo     sequential          crameri
%            roma     sequential          crameri
%            romaO    sequential          crameri
%            tofino   sequential          crameri
%            tokyo    sequential          crameri
%            turku    sequential          crameri
%            vanimo   sequential          crameri
%            vik      sequential          crameri
%            vikO     sequential          crameri
%            Accent   qualitative         cbrewer
%            Dark2    qualitative         cbrewer
%            Paired   qualitative         cbrewer
%            Pastel1  qualitative         cbrewer
%            Pastel2  qualitative         cbrewer
%            Set1     qualitative         cbrewer
%            Set2     qualitative         cbrewer
%            Set3     qualitative         cbrewer
%            Blues    sequential          cbrewer
%            BuGn     sequential          cbrewer
%            BuPu     sequential          cbrewer
%            GnBu     sequential          cbrewer
%            Greens   sequential          cbrewer
%            Greys    sequential          cbrewer
%            Oranges  sequential          cbrewer
%            OrRd     sequential          cbrewer
%            PuBu     sequential          cbrewer
%            PuBuGn   sequential          cbrewer
%            PuRd     sequential          cbrewer
%            Purples  sequential          cbrewer
%            RdPu     sequential          cbrewer
%            Reds     sequential          cbrewer
%            YlGn     sequential          cbrewer
%            YlGnBu   sequential          cbrewer
%            YlOrBr   sequential          cbrewer
%            YlOrRd   sequential          cbrewer
%            BrBG     diverging           cbrewer
%            PiYG     diverging           cbrewer
%            PRGn     diverging           cbrewer
%            PuOr     diverging           cbrewer
%            RdBu     diverging           cbrewer
%            RdGy     diverging           cbrewer
%            RdYlBu   diverging           cbrewer
%            RdYlGn   diverging           cbrewer
%            Spectral diverging           cbrewer
%            deep     sequential          cmocean
%            matter   sequential          cmocean
%            algae    sequential          cmocean
%            dense    sequential          cmocean
%            balance  diverging           cmocean
%            gray     sequential          cmocean
%            oxy      multiple-sequential cmocean
%            solar    sequential          cmocean
%            phase    cyclic              cmocean
%            haline   sequential          cmocean
%            speed    sequential          cmocean
%            thermal  sequential          cmocean
%            turbid   sequential          cmocean
%            delta    diverging           cmocean
%            curl     diverging           cmocean
%            amp      sequential          cmocean
%            tempo    sequential          cmocean
%            ice      sequential          cmocean
%            rain     sequential          cmocean
%            topo     multiple-sequential cmocean
%            diff     diverging           cmocean
%            tarn     diverging           cmocean
%
%     levels - number of entries
%       scalar integer value
%         Number of entries of the colormap, specified as a scalar integer
%         value. The default value of levels is equal to the length of the
%         colormap for the current axes. If no current axes exists the default
%         number of entries depends on the colormap.
%
%     target - target axes
%       Axes object
%         Target axes, specified as an Axes object. If you do not specify the
%         axes, CM sets the colormap for the current axes (returned by gca).
%
%
%   Output Arguments
%     cmap - colormap values
%       three-column matrix of RGB triplets
%         Colormap values, returned as a three-column matrix of RGB triplets.
%         Each row of the matrix defines one RGB triplet that specifies one
%         color of the colormap. The values are in the range [0,1].
%
%
%   Name-Value Pair Arguments
%     Library - name of the color library
%       '' | 'cbrewer' | 'cmocesn' | 'crameri'
%         The name of the color library that the colormap name map belongs to.
%         This is only required if the duplicate colormap names exist across the
%         libraries. It is set to '' and thus ignored by default.
%
%     Invert - invert the colormap
%       false (default) | true
%         If set to true, the colormap is inverted
%
%     Pivot - set pivot number
%       NaN (default) | numeric finite scalar
%         Sets the pivot point for diverging colormaps. The colormap of the
%         current axis is then adjusted so that the colormap center corresponds
%         to the pivot point based on the CLimit property of the current axes.
%         If set to NaN, no pivot number is applied (default).
%
%
%   See also COLORMAP, SHOWGALLERY
%
%   Copyright (c) 2022-2022 David Clemens (dclemens@geomar.de)
%

    import internal.stats.parseArgs
    
    nargoutchk(0,1)
    
    nRemainingArgs	= nargin; % Remaining input argument counter
    iArgs           = 1; % Current input argument counter
    
    % Load raw data
    [colormapData,validMaps,~,validLibraries] = loadCMData;
    validLibraries  = cat(2,validLibraries,{''}); % Append 'no library specified'
    
    % Set defaults        
    showColormaps   = false;
    levels          = 64;
    doPivot         = false;
    
    % Set operating mode
    if nargout == 0
        mode = 'setColormap';
    elseif nargout == 1
        mode = 'returnColormap';
    end
    
    % Find existing axes in the current figure
    graphicsRoot    = groot;
    target          = findobj(graphicsRoot.CurrentFigure,'Type','axes');
    if isempty(target)
        createAxes  = true;
    else
        createAxes  = false;
        target      = target(1);
    end
    
    % Extract inputs
    if nRemainingArgs == 0
        % If no input is given
        showColormaps	= true;
    elseif nRemainingArgs >= 1
        % Extract target figure or axes if supplied
        if isa(varargin{1},'matlab.graphics.axis.Axes')
            if nRemainingArgs >= 2
                validateattributes(varargin{1},{'matlab.graphics.axis.Axes'},{'scalar','nonempty'},mfilename,'target',iArgs)
                target      = varargin{1};
                createAxes  = false;
                varargin	= varargin(2:end); % Remove the first input from the input argument stack
                
                nRemainingArgs	= nRemainingArgs - 1; % Remove the first input from the remaining input argument counter
                iArgs           = iArgs + 1; % Increment the input argument counter
            else
                error('Colormaps:cm:NotEnoughInputs',...
                    'Not enough inputs.')
            end
        end
        
        % Extract colormap name
        if nRemainingArgs >= 1
            map         = validatestring(varargin{1},validMaps,mfilename,'map',iArgs);
            varargin	= varargin(2:end); % Remove the first input from the input argument stack
            nRemainingArgs	= nRemainingArgs - 1; % Remove the first input from the remaining input argument counter
           	iArgs           = iArgs + 1; % Increment the input argument counter
        end
        
        % Extract number of colormap entries
        if nRemainingArgs >= 1
            if isnumeric(varargin{1})
                validateattributes(varargin{1},{'numeric'},{'scalar','nonempty','finite','integer','positive'},mfilename,'levels',iArgs)
                levels      = varargin{1};
                varargin    = varargin(2:end); % Remove the first input from the input argument stack
            end
        end        
    end
    
    % Parse Name-Value pairs
    optionName          = {'Library','Invert','Pivot'}; % valid options (Name)
    optionDefaultValue  = {'',false,NaN}; % default value (Value)
    [library,...
     invert,...
     pivot]  = parseArgs(optionName,optionDefaultValue,varargin{:}); % parse function arguments

    if showColormaps
        showGallery
        return
    end
    
    % Validate inputs
    if numel(target) == 1 && ~isvalid(target)
        error('Colormaps:cm:InvalidTarget',...
            'The target is not a valid axes handle')
    end
    library	= validatestring(library,validLibraries,mfilename,'Library');
    validateattributes(invert,{'logical'},{'scalar','nonempty'},mfilename,'Invert')
    validateattributes(pivot,{'numeric'},{'scalar','nonempty'},mfilename,'Pivot')

    % Create axes if necessary
    if strcmp(mode,'setColormap') && createAxes
        target = gca;
    end
    
    % Find the requested colormap
    if isempty(library)
        matchLibrary = false;
    else
        matchLibrary = true;
    end
    indexName       = ismember(validMaps,map)';
    indexLibrary    = ismember({colormapData.Library},library)';
    if matchLibrary
        index = find(indexName & indexLibrary);
    else
        index = find(indexName);
    end
    
    % Throw error, if duplicates are found and no library name is specified.
    if numel(index) > 1
        error('Colormaps:cm:NonUniqueColormapName',...
            'The colormap name ''%s'' is not unique. Please also specify the colormap library.',map)
    end
    
    % Set raw colormap entries and type
    raw     = colormapData(index).Data;
    type    = colormapData(index).Type;
    
    % Invert colormap if required
    if invert
        raw = flipud(raw);
    end
    
    % Prepare to pivot
    if isfinite(pivot)
        doPivot = true;
    end
    
    switch type
        case {'S','D','MS','C'}
            % Interpolate to requested levels and pivots
            if doPivot
                % Warn about a set pivot for non-divergin colormaps
                if ~strcmp(type,'D')
                    warning('Colormaps:cm:PivotForNonDivergingColormap',...
                        'A pivot number for a the non-diverging colormap ''%s'' was requested. The center of the colormap is set to the pivot number.',map)
                end
                if createAxes
                    cLim    = [0 1];
                else
                    cLim	= caxis(target);
                end
                maxValue    = max(abs(cLim - pivot)); 
                x   = linspace(-maxValue,maxValue,size(raw,1)) + pivot;
                xq	= linspace(cLim(1),cLim(2),levels);
            else
                x   = 1:size(raw,1);
                xq  = linspace(1,size(raw,1),levels);
            end
            cmap 	= interp1(x,raw,xq,'linear','extrap');
        case 'Q'
            % Warn about repeated colors for qualtitative colormaps
            if levels > size(raw,1)
                warning('Colormaps:cm:NoInterpolationForQualitativeColormaps',...
                    '''%s'' is a qualitative colormap and can''t be interpolated. Colors have been repeated.',map)
            end
            if doPivot
                warning('Colormaps:cm:PivotForQualitativeColormap',...
                    'A pivot number for a the qualitative colormap ''%s'' was requested. Pivots are only valid for non-qualitative colormaps. The pivot is ignored.',map)
            end
            cmap = raw(1 + mod(0:levels - 1,size(raw,1)),:);
    end
    
    switch mode
        case 'setColormap'
            colormap(target,cmap);
        case 'returnColormap'
            varargout{1} = cmap;
    end
end
