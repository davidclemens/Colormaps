function varargout = cm(varargin)

    import internal.stats.parseArgs
    
    nargoutchk(0,1)
    
    % Extract required first argument
    if nargin == 0
        showColormaps	= true;
    elseif nargin == 1
        colormapName    = varargin{1};
        varargin        = {};
        showColormaps   = false;
    elseif nargin > 1
        varargin        = varargin(2:end);
        showColormaps   = false;
    end
    
    % Parse Name-Value pairs
    optionName          = {'Library','Invert','Pivot','Levels'}; % valid options (Name)
    optionDefaultValue  = {'',false,0,256}; % default value (Value)
    [colormapLibrary,...
     invert,...
     pivot,...
     levels]  = parseArgs(optionName,optionDefaultValue,varargin{:}); % parse function arguments
 
    % Load raw data
    colormapData = load([fileparts(mfilename('fullpath')),'/cmData.mat'],'cmData');
    colormapData = colormapData.cmData;

    if showColormaps
        % TODO
        %{
        figure(...
            'menubar',   	'none',...
            'numbertitle',	'off',...
            'Name',       	'cm options:')

        if license('test','image_toolbox')
            imshow(imread('cmocean.png')); 
        else
        	axes('pos',[0 0 1 1])
            image(imread('cmocean.png')); 
            axis image off
        end
        %}
        return
    end
    
    % Validate inputs
    validColormapNames      = {colormapData.Name};
    validColormapLibraries  = {'','cbrewer','cmocean','crameri'};
    colormapName    = validatestring(colormapName,validColormapNames,mfilename,'colormapName',1);
    colormapLibrary	= validatestring(colormapLibrary,validColormapLibraries,mfilename,'colorLibrary');
    validateattributes(invert,{'logical'},{'scalar','nonempty'},mfilename,'Invert')
    validateattributes(pivot,{'numeric'},{'scalar','nonempty','finite'},mfilename,'Pivot')
    validateattributes(levels,{'numeric'},{'scalar','nonempty','finite','integer'},mfilename,'Levels')

    % Find the requested colormap
    if isempty(colormapLibrary)
        matchLibrary = false;
    else
        matchLibrary = true;
    end
    indexName       = ismember(validColormapNames,colormapName)';
    indexLibrary    = ismember({colormapData.Library},colormapLibrary)';
    if matchLibrary
        index = find(indexName & indexLibrary);
    else
        index = find(indexName);
    end
    
    % Throw error, if duplicates are found and not library name is specified.
    if numel(index) > 1
        error('Colormaps:cm:NonUniqueColormapName',...
            'The colormap name ''%s'' is not unique. Please also specify the colormap library.',colormapName)
    end
    
    raw     = colormapData(index).Data;
    
    % Invert colormap if required
    if invert
        raw = flipud(raw);
    end
    
    type    = colormapData(index).Type;
    
    switch type
        case {'S','D','MS','C'}
            % Interpolate if necessary: 
            if levels ~= size(raw,1) 
                cmap = interp1(1:size(raw,1), raw, linspace(1,size(raw,1),levels),'linear');
            else
                cmap = raw;
            end
        case 'Q'
            if levels <= size(raw,1)
                cmap = raw(1:levels,:);
            else
                % TODO maybe repeat colormap to match the requested output levels
                error('Colormaps:cm:NoInterpolationForQualitativeColormaps',...
                    '''%s'' is a qualitative colormap. The can''t be interpolated.')
            end
    end
    
    if nargout == 0
        colormap(cmap);
    elseif nargout == 1
        varargout{1} = cmap;
    end
end
