function startup()
% STARTUP  Set MATLAB path for this project.
% Run once per session: >> startup

% Locate project root
root = fileparts(mfilename('fullpath'));

% Helper: add folder if it exists and isn’t already on path
function addif(p)
    if isfolder(p) && ~contains([path pathsep], [p pathsep])
        addpath(p);
    end
end

% Add root to path
addif(root);

% Non-package utilities to add to path:
addif(fullfile(root, 'scripts'));    
addif(fullfile(root, 'plots'));  
addif(fullfile(root, 'tests'));      
addif(fullfile(root, 'utils'));  

fprintf('[startup] Project root set: %s\n', root);

end
