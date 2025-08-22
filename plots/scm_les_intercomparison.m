%% ========================================================================
%  PLOT SCM INTERCOMPARISON WITH LES
%  ------------------------------------------------------------------------
%  Purpose
%    Generate mean profiles for a comparison of scm runs from different
%    turbulence models with LES data
%
%  Expects in workspace
%    settings.zCell    : Nz×1 heights [m]
%    params.end_time   : scalar [s]
%    avgVars           : struct with fields (…_mn): T_mn, k_mn, e_mn,
%                        nu_t_mn, alpha_t_mn, etc.
%    tsVars            : struct with fields: ustar, ablh, L
%    Derived arrays    : wsph_mn, wdir_mn, vmf_mn
%
%  Output
%    A single figure with an intercomparison of results from different 
%    turbulence models.
%
%  Notes
%    - Uses 'utils/plot_settings' to improve visuals of plots.
%    - If `linspecer` is unavailable, the palette falls back to `lines`.
%
%  Author: Ethan YoungIn Shin
%  Last modified: 2025-08-22
% ========================================================================
clear all; clc;


% Color settings 
if exist('linspecer','file')
    colors = linspecer(8);
else
    warning('linspecer not found; using MATLAB default "lines" palette.');
    colors = lines(8);
end
c1 = colors(1,:); 
c2 = colors(2,:); 
c3 = colors(3,:); 
c4 = colors(4,:); 
c5 = colors(5,:);
c6 = colors(6,:);
c7 = colors(7,:);
c8 = colors(8,:);
transparency = 0.5;


% Bring in SCM data
load('../data/scm/case-tnbl_model-stdke_Gx-12_z0-0p1_20250822_102237.mat')
run_tnbl_stdke = run;
load('../data/scm/case-tnbl_model-mostke_Gx-12_z0-0p1_20250822_102334.mat')
run_tnbl_mostke = run;
load('../data/scm/case-tnbl_model-de85ke_Gx-12_z0-0p1_20250822_120704.mat')
run_tnbl_de85ke = run;
load('../data/scm/case-tnbl_model-rngke_Gx-12_z0-0p1_20250822_122348.mat')
run_tnbl_rngke = run;
load('../data/scm/case-sbl_model-stdke_Gx-8_z0-0p1_20250822_102505.mat')
run_sbl_stdke = run;
load('../data/scm/case-sbl_model-mostke_Gx-8_z0-0p1_20250822_102444.mat')
run_sbl_mostke = run;
load('../data/scm/case-sbl_model-de85ke_Gx-8_z0-0p1_20250822_121426.mat')
run_sbl_de85ke = run;
load('../data/scm/case-sbl_model-rngke_Gx-8_z0-0p1_20250822_115127.mat')
run_sbl_rngke = run;

% Preparing vertical axis
z_tnbl = run_tnbl_stdke.settings.zCell(:);
z_sbl = run_sbl_stdke.settings.zCell(:);
ztop_tnbl = 3000;
ztop_sbl = 300;

% Preparing derived mean quantities for SCM
% Wind speed
run_tnbl_stdke.avg.wsph_mn = hypot(run_tnbl_stdke.avg.u_mn, run_tnbl_stdke.avg.v_mn);
run_tnbl_mostke.avg.wsph_mn = hypot(run_tnbl_mostke.avg.u_mn, run_tnbl_mostke.avg.v_mn);
run_tnbl_de85ke.avg.wsph_mn = hypot(run_tnbl_de85ke.avg.u_mn, run_tnbl_de85ke.avg.v_mn);
run_tnbl_rngke.avg.wsph_mn = hypot(run_tnbl_rngke.avg.u_mn, run_tnbl_rngke.avg.v_mn);
run_sbl_stdke.avg.wsph_mn = hypot(run_sbl_stdke.avg.u_mn, run_sbl_stdke.avg.v_mn);
run_sbl_mostke.avg.wsph_mn = hypot(run_sbl_mostke.avg.u_mn, run_sbl_mostke.avg.v_mn);
run_sbl_de85ke.avg.wsph_mn = hypot(run_sbl_de85ke.avg.u_mn, run_sbl_de85ke.avg.v_mn);
run_sbl_rngke.avg.wsph_mn = hypot(run_sbl_rngke.avg.u_mn, run_sbl_rngke.avg.v_mn);

% Wind direction
run_tnbl_stdke.avg.wdir_mn = atand(run_tnbl_stdke.avg.v_mn./run_tnbl_stdke.avg.u_mn);
run_tnbl_mostke.avg.wdir_mn = atand(run_tnbl_mostke.avg.v_mn./run_tnbl_mostke.avg.u_mn);
run_tnbl_de85ke.avg.wdir_mn = atand(run_tnbl_de85ke.avg.v_mn./run_tnbl_de85ke.avg.u_mn);
run_tnbl_rngke.avg.wdir_mn = atand(run_tnbl_rngke.avg.v_mn./run_tnbl_rngke.avg.u_mn);
run_sbl_stdke.avg.wdir_mn = atand(run_sbl_stdke.avg.v_mn./run_sbl_stdke.avg.u_mn);
run_sbl_mostke.avg.wdir_mn = atand(run_sbl_mostke.avg.v_mn./run_sbl_mostke.avg.u_mn);
run_sbl_de85ke.avg.wdir_mn = atand(run_sbl_de85ke.avg.v_mn./run_sbl_de85ke.avg.u_mn);
run_sbl_rngke.avg.wdir_mn = atand(run_sbl_rngke.avg.v_mn./run_sbl_rngke.avg.u_mn);

% Vertical momentum flux
run_tnbl_stdke.avg.vmf_mn = hypot(run_tnbl_stdke.avg.uw_mn, run_tnbl_stdke.avg.vw_mn);
run_tnbl_mostke.avg.vmf_mn = hypot(run_tnbl_mostke.avg.uw_mn, run_tnbl_mostke.avg.vw_mn);
run_tnbl_de85ke.avg.vmf_mn = hypot(run_tnbl_de85ke.avg.uw_mn, run_tnbl_de85ke.avg.vw_mn);
run_tnbl_rngke.avg.vmf_mn = hypot(run_tnbl_rngke.avg.uw_mn, run_tnbl_rngke.avg.vw_mn);
run_sbl_stdke.avg.vmf_mn = hypot(run_sbl_stdke.avg.uw_mn, run_sbl_stdke.avg.vw_mn);
run_sbl_mostke.avg.vmf_mn = hypot(run_sbl_mostke.avg.uw_mn, run_sbl_mostke.avg.vw_mn);
run_sbl_de85ke.avg.vmf_mn = hypot(run_sbl_de85ke.avg.uw_mn, run_sbl_de85ke.avg.vw_mn);
run_sbl_rngke.avg.vmf_mn = hypot(run_sbl_rngke.avg.uw_mn, run_sbl_rngke.avg.vw_mn);


% Bring in LES data
load("../data/les/sbl_10min.mat");
load("../data/les/tnbl_10min.mat");

% Preparing derived mean quantities for LES
% Wind speed
tnbl_wsph = hypot(tnbl_ubar, tnbl_vbar);
sblm_wsph = hypot(sblm_ubar, sblm_vbar);
% Wind direction
tnbl_wdir = atand(tnbl_vbar./tnbl_ubar);
sblm_wdir = atand(sblm_vbar./sblm_ubar);

% Compute spread and mean of quantities for LES
[tnbl_wsph_spread, tnbl_wsph_mn] = compute_spread(run_tnbl_stdke.settings.Gx*tnbl_wsph');
[sblm_wsph_spread, sblm_wsph_mn] = compute_spread(run_sbl_stdke.settings.Gx*sblm_wsph');
[tnbl_wdir_spread, tnbl_wdir_mn] = compute_spread(tnbl_wdir');
[sblm_wdir_spread, sblm_wdir_mn] = compute_spread(sblm_wdir');
[tnbl_T_spread, tnbl_T_mn] = compute_spread(tnbl_Tbar');
[sblm_T_spread, sblm_T_mn] = compute_spread(sblm_Tbar');
[tnbl_vmf_spread, tnbl_vmf_mn] = compute_spread(run_tnbl_stdke.settings.Gx^2*tnbl_vmf');
[sblm_vmf_spread, sblm_vmf_mn] = compute_spread(run_sbl_stdke.settings.Gx^2*sblm_vmf');
[tnbl_k_spread, tnbl_k_mn] = compute_spread(run_tnbl_stdke.settings.Gx^2*tnbl_k');
[sblm_k_spread, sblm_k_mn] = compute_spread(run_sbl_stdke.settings.Gx^2*sblm_k');

% Separate vertical axis for filling
z_tnbl_fill = [z_tnbl' flipud(z_tnbl)'];
z_sbl_fill = [z_sbl' flipud(z_sbl)'];


%% Intercomparison of mean profiles for TNBL

fig = figure('Color','w', "Position", [300,300,1000,500]);

% collect axes handle
ax = gobjects(6,1);

ax(1) = nexttile; hold on;
fill(tnbl_wsph_spread, z_tnbl_fill, c8, 'FaceAlpha', transparency, "EdgeColor","none");
plot(run_tnbl_stdke.avg.wsph_mn, z_tnbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_mostke.avg.wsph_mn, z_tnbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_de85ke.avg.wsph_mn, z_tnbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_rngke.avg.wsph_mn, z_tnbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$\overline{U}\;[\mathrm{m\,s^{-1}}]$'); 
ylabel('$z\;[\mathrm{m}]$');
ylim([0,ztop_tnbl]); 
xlim([0,14]); 
plot_settings;
title('Wind speed');

ax(2) = nexttile; hold on;
fill(tnbl_wdir_spread, z_tnbl_fill, c8, 'FaceAlpha', transparency, "EdgeColor","none");
plot(run_tnbl_stdke.avg.wdir_mn, z_tnbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_mostke.avg.wdir_mn, z_tnbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_de85ke.avg.wdir_mn, z_tnbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_rngke.avg.wdir_mn, z_tnbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$\overline{\phi}\;[^\circ]$'); 
ylabel('$z\;[\mathrm{m}]$');
ylim([0,ztop_tnbl]); 
xlim([0,30]); 
plot_settings; 
title('Wind direction');

ax(3) = nexttile; hold on;
fill(tnbl_T_spread, z_tnbl_fill, c8, 'FaceAlpha', transparency, "EdgeColor","none");
plot(run_tnbl_stdke.avg.T_mn, z_tnbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_mostke.avg.T_mn, z_tnbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_de85ke.avg.T_mn, z_tnbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_rngke.avg.T_mn, z_tnbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$\overline{\theta}\;[\mathrm{K}]$'); 
ylabel('$z\;[\mathrm{m}]$');
ylim([0,ztop_tnbl]); 
xlim([299,301])
plot_settings; 
title('Potential temperature');

ax(4) = nexttile; hold on;  
fill(tnbl_vmf_spread, z_tnbl_fill, c8, 'FaceAlpha', transparency, "EdgeColor","none");
plot(run_tnbl_stdke.avg.vmf_mn, z_tnbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_mostke.avg.vmf_mn, z_tnbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_de85ke.avg.vmf_mn, z_tnbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_rngke.avg.vmf_mn, z_tnbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$|\overline{\tau}/\rho|\;[\mathrm{m^2\,s^{-2}}]$'); 
ylabel('$z\;[\mathrm{m}]$');
ylim([0,ztop_tnbl]); 
plot_settings; 
title('Vertical momentum flux');

ax(5) = nexttile; hold on;  
fill(tnbl_k_spread, z_tnbl_fill, c8, 'FaceAlpha', transparency, "EdgeColor","none");
plot(run_tnbl_stdke.avg.k_mn, z_tnbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_mostke.avg.k_mn, z_tnbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_de85ke.avg.k_mn, z_tnbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_rngke.avg.k_mn, z_tnbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$\overline{k}\;[\mathrm{m^2\,s^{-2}}]$'); 
ylabel('$z\;[\mathrm{m}]$');
ylim([0,ztop_tnbl]);
plot_settings; 
title('TKE');

ax(6) = nexttile; hold on;  
plot(run_tnbl_stdke.avg.nu_t_mn, z_tnbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_mostke.avg.nu_t_mn, z_tnbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_de85ke.avg.nu_t_mn, z_tnbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_tnbl_rngke.avg.nu_t_mn, z_tnbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$\overline{\nu}_t\;[\mathrm{m^2\,s^{-1}}]$'); ylabel('$z\;(\mathrm{m})$');
ylim([0,ztop_tnbl]); 
plot_settings; 
title('Eddy viscosity');

legend(ax(5), "LES", "STD $k$-$\epsilon$", "MOST $k$-$\epsilon$", ...
    "DE85 $k$-$\epsilon$", "RNG $k$-$\epsilon$", 'Location', 'northeast', 'FontSize', 16, 'Interpreter', 'latex')

% Save in figs folder
print(gcf, fullfile('figs','scm_les_intercomparison_tnbl.png'), '-dpng', '-r300')


%% Intercomparison of mean profiles for SBL

fig = figure('Color','w', "Position", [300,300,1000,500]);

% collect axes handle
ax = gobjects(6,1);

ax(1) = nexttile; hold on;
fill(sblm_wsph_spread, z_sbl_fill, c8, 'FaceAlpha', transparency, "EdgeColor","none");
plot(run_sbl_stdke.avg.wsph_mn, z_sbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_mostke.avg.wsph_mn, z_sbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_de85ke.avg.wsph_mn, z_sbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_rngke.avg.wsph_mn, z_sbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$\overline{U}\;[\mathrm{m\,s^{-1}}]$'); 
ylabel('$z\;[\mathrm{m}]$');
ylim([0,ztop_sbl]); 
xlim([0,14]); 
plot_settings;
title('Wind speed');

ax(2) = nexttile; hold on;
fill(sblm_wdir_spread, z_sbl_fill, c8, 'FaceAlpha', transparency, "EdgeColor","none");
plot(run_sbl_stdke.avg.wdir_mn, z_sbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_mostke.avg.wdir_mn, z_sbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_de85ke.avg.wdir_mn, z_sbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_rngke.avg.wdir_mn, z_sbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$\overline{\phi}\;[^\circ]$'); 
ylabel('$z\;[\mathrm{m}]$');
ylim([0,ztop_sbl]); 
xlim([0,45]); 
plot_settings; 
title('Wind direction');

ax(3) = nexttile; hold on;
fill(sblm_T_spread, z_sbl_fill, c8, 'FaceAlpha', transparency, "EdgeColor","none");
plot(run_sbl_stdke.avg.T_mn, z_sbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_mostke.avg.T_mn, z_sbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_de85ke.avg.T_mn, z_sbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_rngke.avg.T_mn, z_sbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$\overline{\theta}\;[\mathrm{K}]$'); 
ylabel('$z\;[\mathrm{m}]$');
ylim([0,ztop_sbl]); 
plot_settings; 
title('Potential temperature');

ax(4) = nexttile; hold on;  
fill(sblm_vmf_spread, z_sbl_fill, c8, 'FaceAlpha', transparency, "EdgeColor","none");
plot(run_sbl_stdke.avg.vmf_mn, z_sbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_mostke.avg.vmf_mn, z_sbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_de85ke.avg.vmf_mn, z_sbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_rngke.avg.vmf_mn, z_sbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$|\overline{\tau}/\rho|\;[\mathrm{m^2\,s^{-2}}]$'); 
ylabel('$z\;[\mathrm{m}]$');
ylim([0,ztop_sbl]); 
plot_settings; 
title('Vertical momentum flux');

ax(5) = nexttile; hold on;  
fill(sblm_k_spread, z_sbl_fill, c8, 'FaceAlpha', transparency, "EdgeColor","none");
plot(run_sbl_stdke.avg.k_mn, z_sbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_mostke.avg.k_mn, z_sbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_de85ke.avg.k_mn, z_sbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_rngke.avg.k_mn, z_sbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$\overline{k}\;[\mathrm{m^2\,s^{-2}}]$'); 
ylabel('$z\;[\mathrm{m}]$');
ylim([0,ztop_sbl]);
plot_settings; 
title('TKE');

ax(6) = nexttile; hold on;  
plot(run_sbl_stdke.avg.nu_t_mn, z_sbl, 'Color', c1, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_mostke.avg.nu_t_mn, z_sbl, 'Color', c2, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_de85ke.avg.nu_t_mn, z_sbl, 'Color', c3, 'LineWidth',1.5, 'LineStyle', '-');
plot(run_sbl_rngke.avg.nu_t_mn, z_sbl, 'Color', c4, 'LineWidth',1.5, 'LineStyle', '-');
xlabel('$\overline{\nu}_t\;[\mathrm{m^2\,s^{-1}}]$'); ylabel('$z\;(\mathrm{m})$');
ylim([0,ztop_sbl]); 
xlim([0,10])
plot_settings; 
title('Eddy viscosity');

legend(ax(5), "LES", "STD $k$-$\epsilon$", "MOST $k$-$\epsilon$", ...
    "DE85 $k$-$\epsilon$", "RNG $k$-$\epsilon$", 'Location', 'northeast', 'FontSize', 16, 'Interpreter', 'latex')

% Save in figs folder
print(gcf, fullfile('figs','scm_les_intercomparison_sbl.png'), '-dpng', '-r300')