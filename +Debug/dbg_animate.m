function mov = dbg_animate(qoi, z, varargin)
%DBG_ANIMATE: Debugger-friendly animation of vertical profiles.
%   mov = ANIMATE_PROFILE(qoi, z, 'Step', 100, 'FPS', 20, ...
%                         'SaveVideo', false, 'Filename', 'profile.mp4', ...
%                         'Figure', 2, 'LineWidth', 2)
%
%   qoi : [Nz x Nt] array (e.g., u_store). Each column is a profile.
%   z   : [Nz x 1] or [1 x Nz] height vector (e.g., params.zCell).
%
%   Returns:
%     mov : struct array of frames (usable with MOVIE).

% ---- Parse options -------------------------------------------------------
p = inputParser;
p.addParameter('Step',      100, @(x)isnumeric(x) && isscalar(x) && x>=1);
p.addParameter('FPS',       20,  @(x)isnumeric(x) && isscalar(x) && x>0);
p.addParameter('SaveVideo', false, @(x)islogical(x) || isnumeric(x));
p.addParameter('Filename',  'profile.mp4', @(s)ischar(s) || isstring(s));
p.addParameter('Figure',    2,   @(x)isnumeric(x) && isscalar(x));
p.addParameter('LineWidth', 2,   @(x)isnumeric(x) && isscalar(x) && x>0);
p.parse(varargin{:});
opt = p.Results;

% ---- Validate inputs -----------------------------------------------------
z = z(:);
assert(isnumeric(qoi) && ismatrix(qoi), 'qoi must be a numeric [Nz x Nt] matrix.');
assert(size(qoi,1) == numel(z), 'Row count of qoi must equal numel(z).');

[Nz, Nt] = size(qoi);
idx      = 1:opt.Step:Nt;
nFrames  = numel(idx);

% ---- Figure/axes setup ---------------------------------------------------
fig = figure(opt.Figure); clf(fig); set(fig, 'Color', 'w');
ax  = axes('Parent', fig);
hold(ax, 'on'); grid(ax, 'on'); box(ax, 'on');
set(ax, 'FontSize', 14);

% Fix x-limits
xmin = min(qoi(:));
xmax = max(qoi(:));
dx   = 0.05 * max(1, abs(xmax - xmin));
xlim(ax, [xmin - dx, xmax + dx]);
ylim(ax, [min(z), max(z)]);

plot_settings;

% Initial plot
h = plot(ax, qoi(:, idx(1)), z, '-', 'LineWidth', opt.LineWidth);

xlabel(ax, 'U [m s^{-1}]', 'Interpreter', 'latex');
ylabel(ax, 'Height [m]',   'Interpreter', 'latex');
title(ax, sprintf('Frame %d/%d (column %d)', 1, nFrames, idx(1)));

% ---- Preallocate movie frames -------------------------------------------
mov(nFrames) = struct('cdata', [], 'colormap', []);

% ---- Optional video writer ----------------------------------------------
if opt.SaveVideo
    vw = VideoWriter(char(opt.Filename), 'MPEG-4');
    vw.FrameRate = opt.FPS;
    open(vw);
end

% ---- Animate -------------------------------------------------------------
t0 = tic;
for k = 1:nFrames
    j = idx(k);
    set(h, 'XData', qoi(:, j), 'YData', z);
    title(ax, sprintf('Frame %d/%d (column %d)', k, nFrames, j));
    drawnow limitrate nocallbacks;

    mov(k) = getframe(fig);
    if opt.SaveVideo
        writeVideo(vw, mov(k));
    end
end

if opt.SaveVideo
    close(vw);
end

fprintf('Rendered %d frames in %.2f s.\n', nFrames, toc(t0));

end
