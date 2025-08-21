%% PLOT SCM STATISTICS AFTER RUN (DON'T ERASE VARIABLES FROM WORKSPACE AFTER RUN)
% by Ethan YoungIn Shin
% Last modified: 10/09/2024

% Color settings
colors = linspecer(8);
transparency = 0.5;

% LES DATA
load("../../les_data_plot/les_data/sblw_samples_10min.mat");
load("../../les_data_plot/les_data/sblm_samples_10min.mat");
load("../../les_data_plot/les_data/sbls15_samples_10min.mat");
load("../../les_data_plot/les_data/tnbl_samples_10min.mat");

tnbl_Ubar = sqrt(tnbl_ubar.^2 + tnbl_vbar.^2);
sblw_Ubar = sqrt(sblw_ubar.^2 + sblw_vbar.^2);
sblm_Ubar = sqrt(sblm_ubar.^2 + sblm_vbar.^2);
sbls_Ubar = sqrt(sbls_ubar.^2 + sbls_vbar.^2);
tnbl_Udir = atand(tnbl_vbar./tnbl_ubar);
sblw_Udir = atand(sblw_vbar./sblw_ubar);
sblm_Udir = atand(sblm_vbar./sblm_ubar);
sbls_Udir = atand(sbls_vbar./sbls_ubar);

% compute spread and means of QOIs
[tnbl_Ubar_spread, tnbl_Ubar_mean] = compute_spread(tnbl_Ubar');
[sblw_Ubar_spread, sblw_Ubar_mean] = compute_spread(sblw_Ubar');
[sblm_Ubar_spread, sblm_Ubar_mean] = compute_spread(sblm_Ubar');
[sbls_Ubar_spread, sbls_Ubar_mean]= compute_spread(sbls_Ubar');
[tnbl_Udir_spread, tnbl_Udir_mean] = compute_spread(tnbl_Udir');
[sblw_Udir_spread, sblw_Udir_mean] = compute_spread(sblw_Udir');
[sblm_Udir_spread, sblm_Udir_mean] = compute_spread(sblm_Udir');
[sbls_Udir_spread, sbls_Udir_mean]= compute_spread(sbls_Udir');
[tnbl_Tbar_spread, tnbl_Tbar_mean] = compute_spread(tnbl_Tbar');
[sblw_Tbar_spread, sblw_Tbar_mean] = compute_spread(sblw_Tbar');
[sblm_Tbar_spread, sblm_Tbar_mean] = compute_spread(sblm_Tbar');
[sbls_Tbar_spread, sbls_Tbar_mean]= compute_spread(sbls_Tbar');
[tnbl_k_spread, tnbl_k_mean] = compute_spread(tnbl_k');
[sblw_k_spread, sblw_k_mean] = compute_spread(sblw_k');
[sblm_k_spread, sblm_k_mean] = compute_spread(sblm_k');
[sbls_k_spread, sbls_k_mean]= compute_spread(sbls_k');
[tnbl_vmf_spread, tnbl_vmf_mean] = compute_spread(tnbl_vmf');
[sblw_vmf_spread, sblw_vmf_mean] = compute_spread(sblw_vmf');
[sblm_vmf_spread, sblm_vmf_mean] = compute_spread(sblm_vmf');
[sbls_vmf_spread, sbls_vmf_mean]= compute_spread(sbls_vmf');


casename = "sblm";

if casename == "sblm" || casename == "sblw"
    % DOMAIN SETTINGS 
    settings.Lz = 400;                                                        % height [m]   
    settings.nz = 64;                                                         % grid points   
    settings.zEdge = linspace(0,settings.Lz,settings.nz+1);                    % grid edges
    settings.zCell = 0.5*(settings.zEdge(2:end) + settings.zEdge(1:end-1));    % grid mid-cells
    zCell_fill_axis = [settings.zCell, fliplr(settings.zCell)];

    % PLOT WIND SPEED
    U_mean = sqrt(outputs(:,1).^2 + outputs(:,2).^2);
    
    % SBL log law
    % params.L = - params.potT0 * ts_outputs(1,end)^3 / (params.kappa * params.g * -0.01);
    % u_loglaw = (ts_outputs(1,end)/0.4)*(log(params.zCell/params.z0) + 5 * (params.zCell / params.L));
    % % NBL log law
    % u_loglaw = (ts_outputs(1,end)/0.4)*log(params.zCell/params.z0);
    
    
    figure('Position',[100,100,1200,300]); hold on;
    
    subplot(1,4,1); hold on;
    plot(U_mean,params.zCell, 'Color', colors(1,:));
    fill(8*sblm_Ubar_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    plot(8*sblm_Ubar_mean, settings.zCell, 'Color', colors(2,:));
    % fill(12*tnbl_Ubar_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    % plot(12*tnbl_Ubar_mean, settings.zCell, 'Color', colors(2,:));
    % plot(u_loglaw,params.zCell, 'Color', 'k', "LineStyle", "--");
    xlabel('$\overline{U}~(ms^{-1}$)'); 
    ylabel('$z~(m)$');
    % ylim([0,400])
    % xlim([0,10])
    plot_settings;
    % set(gca, 'YScale', 'log')
    % view([90 -90]);
   
    % PLOT WIND DIRECTION
    phi_mean = atand(outputs(:,2)./outputs(:,1));
    subplot(1,4,2); hold on;
    plot(phi_mean,params.zCell, '-', 'Color', colors(1,:));
    fill(sblm_Udir_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    plot(sblm_Udir_mean, settings.zCell, 'Color', colors(2,:));
    % fill(tnbl_Udir_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    % plot(tnbl_Udir_mean, settings.zCell, 'Color', colors(2,:));
    xlabel('$\overline{\phi}~(\circ)$');
    ylabel('$z~(m)$');
    plot_settings;
    % ylim([0,400])
    
    % PLOT POTENTIAL TEMPERATURE
    subplot(1,4,3); hold on;
    plot(outputs(:,3),params.zCell, '-', 'Color', colors(1,:), 'linewidth', 2);
    fill(sblm_Tbar_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    plot(sblm_Tbar_mean, settings.zCell, 'Color', colors(2,:));
    % fill(tnbl_Tbar_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    % plot(tnbl_Tbar_mean, settings.zCell, 'Color', colors(2,:));
    xlabel('$\theta~(K)$');
    ylabel('$z~(m)$');
    plot_settings;
    % ylim([0,400])
    % xlim([299,301])
    
    % PLOT TKE
    subplot(1,4,4);hold on;
    plot(outputs(:,4),params.zCell, '-', 'Color', colors(1,:), 'linewidth', 2);
    fill(64*sblm_k_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    plot(64*sblm_k_mean, settings.zCell, 'Color', colors(2,:));
    xlabel('$k~(m^2~s^{-1})$');
    ylabel('$z~(m)$');
    plot_settings;
    % ylim([0,400])
    % xlim([299,301])

elseif casename == "tnbl"
    settings.Lz = 5000;                                                        % height [m]   
    settings.nz = 360;                                                         % grid points   
    settings.zEdge = linspace(0,settings.Lz,settings.nz+1);                    % grid edges
    settings.zCell = 0.5*(settings.zEdge(2:end) + settings.zEdge(1:end-1));    % grid mid-cells
    zCell_fill_axis = [settings.zCell, fliplr(settings.zCell)];

    % PLOT WIND SPEED
    U_mean = sqrt(outputs(:,1).^2 + outputs(:,2).^2);
    
    % SBL log law
    % params.L = - params.potT0 * ts_outputs(1,end)^3 / (params.kappa * params.g * -0.01);
    % u_loglaw = (ts_outputs(1,end)/0.4)*(log(params.zCell/params.z0) + 5 * (params.zCell / params.L));
    % % NBL log law
    % u_loglaw = (ts_outputs(1,end)/0.4)*log(params.zCell/params.z0);
    
    
    figure('Position',[100,100,1200,300]); hold on;
    
    subplot(1,4,1); hold on;
    plot(U_mean,params.zCell, 'Color', colors(1,:));
    fill(12*tnbl_Ubar_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    plot(12*tnbl_Ubar_mean, settings.zCell, 'Color', colors(2,:));
    % plot(u_loglaw,params.zCell, 'Color', 'k', "LineStyle", "--");
    xlabel('$\overline{U}~(ms^{-1}$)'); 
    ylabel('$z~(m)$');
    % ylim([0,400])
    % xlim([0,10])
    plot_settings;
    % set(gca, 'YScale', 'log')
    % view([90 -90]);
    
    % PLOT WIND DIRECTION
    phi_mean = atand(outputs(:,2)./outputs(:,1));
    subplot(1,4,2); hold on;
    plot(phi_mean,params.zCell, '-', 'Color', colors(1,:));
    fill(tnbl_Udir_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    plot(tnbl_Udir_mean, settings.zCell, 'Color', colors(2,:));
    xlabel('$\overline{\phi}~(\circ)$');
    ylabel('$z~(m)$');
    plot_settings;
    % ylim([0,400])
    
    
    % PLOT POTENTIAL TEMPERATURE
    subplot(1,4,3); hold on;
    plot(outputs(:,3),params.zCell, '-', 'Color', colors(1,:), 'linewidth', 2);
    fill(tnbl_Tbar_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    plot(tnbl_Tbar_mean, settings.zCell, 'Color', colors(2,:));
    xlabel('$\theta~(K)$');
    ylabel('$z~(m)$');
    plot_settings;
    % ylim([0,400])
    xlim([299,301])
    
    % PLOT TKE
    subplot(1,4,4);hold on;
    plot(outputs(:,4),params.zCell, '-', 'Color', colors(1,:), 'linewidth', 2);
    fill(144*tnbl_k_spread, zCell_fill_axis, colors(2,:), 'FaceAlpha', 0.3, "EdgeColor","none");
    plot(144*tnbl_k_mean, settings.zCell, 'Color', colors(2,:));
    xlabel('$k~(m^2~s^{-1})$');
    ylabel('$z~(m)$');
    plot_settings;
    % ylim([0,400])
    % xlim([299,301])
end