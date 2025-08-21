%% ========================================================================
%  SCM POSTPROCESSING & PLOTS
%  ------------------------------------------------------------------------
%  Purpose
%    Generate profile and time-series figures for a Single-Column Model run.
%    Designed to be executed **after** `scm_run` so it reads results already
%    in the workspace (no variables are cleared).
%
%  Expects in workspace
%    settings.zCell    : Nz×1 heights [m]
%    params.end_time   : scalar [s]
%    avgVars           : struct with fields (…_mn): T_mn, k_mn, e_mn,
%                        nu_t_mn, alpha_t_mn, etc.
%    tsVars            : struct with fields: ustar, ablh, L
%    Derived arrays    : wsph_mn, wdir_mn, vmf_mn, vhf_mn, l_m
%
%  Output
%    A single figure (tiled subplots) with profiles and time series.
%
%  Usage
%    % after running main/scm_run:
%    run('plots/plot_scm_statistics.m')     % script form
%
%  Notes
%    - Uses LaTeX interpreters for labels.
%    - If `linspecer` is unavailable, the palette falls back to `lines`.
%
%  Author: Ethan YoungIn Shin
%  Last modified: 2025-08-21
% ========================================================================


% Color settings 
if exist('linspecer','file')
    colors = linspecer(8);
else
    warning('linspecer not found; using MATLAB default "lines" palette.');
    colors = lines(8);
end
c1 = colors(1,:); c3 = colors(3,:); c6 = colors(6,:);
transparency = 0.5;


% Preprocessing
z = settings.zCell(:);
wsph_mn = hypot(avgVars.u_mn, avgVars.v_mn);
wdir_mn = atand(avgVars.v_mn./avgVars.u_mn);
vmf_mn = hypot(avgVars.uw_mn, avgVars.vw_mn);
vhf_mn = (settings.g/settings.potT0) * avgVars.wT_mn;
l_m = params.C_mu^0.75 * avgVars.k_mn .* sqrt(avgVars.k_mn) ./ avgVars.e_mn;
time = linspace(0, settings.end_time, numel(tsVars.ustar))/3600;


%% Combined plot: profiles + time series

fig = figure('Color','w', "Position", [100,100,1200,900]);

% collect axes handle
ax = gobjects(13,1);

ax(1) = nexttile;  
plot(wsph_mn, z, 'Color', c1, 'LineWidth',1.5);
xlabel('$\overline{U}\;[\mathrm{m\,s^{-1}}]$'); 
ylabel('$z\;(\mathrm{m})$');
ylim([0,3000]); 
xlim([0,14]); 
plot_settings;
title('Wind speed');

ax(2) = nexttile;  
plot(wdir_mn, z, 'Color', c1, 'LineWidth',1.5);
xlabel('$\overline{\phi}\;[^\circ]$'); 
ylabel('$z\;(\mathrm{m})$');
ylim([0,3000]); 
xlim([0,30]); 
plot_settings; 
title('Wind direction');

ax(3) = nexttile;  
plot(avgVars.T_mn, z, 'Color', c1, 'LineWidth',1.5);
xlabel('$\overline{\theta}\;[\mathrm{K}]$'); 
ylabel('$z\;(\mathrm{m})$');
ylim([0,3000]); 
plot_settings; 
title('Potential temperature');

ax(4) = nexttile;  
plot(vmf_mn, z, 'Color', c1, 'LineWidth',1.5);
xlabel('$\overline{\tau}/\rho\;[\mathrm{m^2\,s^{-2}}]$'); 
ylabel('$z\;(\mathrm{m})$');
ylim([0,3000]); 
plot_settings; 
title('Vertical momentum flux');

ax(5) = nexttile;  
plot(vhf_mn, z, 'Color', c1, 'LineWidth',1.5);
xlabel('$\overline{w''\theta''}\;[\mathrm{m\,K\,s^{-1}}]$'); 
ylabel('$z\;(\mathrm{m})$');
ylim([0,3000]); 
plot_settings; 
title('Vertical heat flux');

ax(6) = nexttile;  
plot(avgVars.k_mn, z, 'Color', c1, 'LineWidth',1.5);
xlabel('$\overline{k}\;[\mathrm{m^2\,s^{-2}}]$'); 
ylabel('$z\;(\mathrm{m})$');
ylim([0,3000]);
plot_settings; 
title('TKE');

ax(7) = nexttile;  
plot(avgVars.e_mn, z, 'Color', c1, 'LineWidth',1.5);
xlabel('$\overline{\epsilon}\;[\mathrm{m^2\,s^{-3}}]$'); 
ylabel('$z\;(\mathrm{m})$');
ylim([0,3000]); 
plot_settings; 
title('Dissipation');

ax(8) = nexttile;  
plot(avgVars.nu_t_mn, z, 'Color', c1, 'LineWidth',1.5);
xlabel('$\overline{\nu}_t\;[\mathrm{m^2\,s^{-1}}]$'); ylabel('$z\;(\mathrm{m})$');
ylim([0,3000]); 
plot_settings; 
title('Eddy viscosity');

ax(9) = nexttile;  
plot(avgVars.alpha_t_mn, z, 'Color', c1, 'LineWidth',1.5);
xlabel('$\overline{\alpha}_t\;[\mathrm{m^2\,s^{-1}}]$'); ylabel('$z\;(\mathrm{m})$');
ylim([0,3000]); 
plot_settings; 
title('Eddy diffusivity');

ax(10) = nexttile; 
plot(l_m, z, 'Color', c1, 'LineWidth',1.5);
xlabel('$\ell_m\;[\mathrm{m}]$'); ylabel('$z\;(\mathrm{m})$');
ylim([0,3000]); 
plot_settings; 
title('Mixing length');

% --- Row 3: time series ---
ax(11) = nexttile; 
plot(time, tsVars.ustar, 'Color', c1, 'LineWidth',1.5);
ylabel('$u_* \;[\mathrm{m\,s^{-1}}]$'); 
xlabel('$t \;[\mathrm{h}]$');
plot_settings; 
title('Friction velocity');

ax(12) = nexttile; 
plot(time, tsVars.ablh, 'Color', c1, 'LineWidth',1.5);
ylabel('$\delta_{\mathrm{ABL}} \;[\mathrm{m}]$'); 
xlabel('$t \;[\mathrm{h}]$');
plot_settings; 
title('ABL height');

ax(13) = nexttile; 
plot(time, tsVars.L, 'Color', c1, 'LineWidth',1.5);
ylabel('$L \;[\mathrm{m}]$'); 
xlabel('$t \;[\mathrm{h}]$');
plot_settings; 
title('Obukhov length');

% Link all profile plots by height
linkaxes(ax(1:10), 'y');

