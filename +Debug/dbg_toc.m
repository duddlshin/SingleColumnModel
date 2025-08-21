function elapsed = dbg_toc(t, enabled, label)
%DBG_TOC: Stop a timer started by dbg_tic and print elapsed time if enabled.
%   elapsed = DBG_TOC(t, enabled, label)
if nargin < 2 || isempty(enabled), enabled = true; end
if nargin < 3, label = ''; end

if ~enabled || isempty(t)
    elapsed = 0;
    return
end

elapsed = toc(t);
if ~isempty(label)
    fprintf('[TIMER] %s: %.3f s\n', label, elapsed);
else
    fprintf('Elapsed Time: %.3f s\n', elapsed);
end
end
