function c = dbg_timer(enabled, label)
%DBG_SCOPE: Prints elapsed time automatically when 'c' is cleared or goes out of scope.
if nargin < 1 || isempty(enabled), enabled = true; end
if nargin < 2, label = ''; end
if ~enabled
    c = onCleanup(@() []);
    return
end
t0 = tic;
c  = onCleanup(@() fprintf('[TIMER] %s: %.3f s\n', label, toc(t0)));
end
