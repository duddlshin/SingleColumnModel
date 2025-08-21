function t = dbg_tic(enabled, label)
%DBG_TIC: Start a timer if enabled; return empty otherwise.
%   t = DBG_TIC(enabled, label)
if nargin < 1 || isempty(enabled), enabled = true; end
if nargin < 2, label = ''; end

if enabled
    if ~isempty(label)
        fprintf('[TIMER] %s ...\n', label);
    end
    t = tic;
else
    t = [];
end
end
