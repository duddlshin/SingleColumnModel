%% Single-Column Model - Main
% Author: Ethan YoungIn Shin
% Last modified: 2025-08-22
% -------------------------------------------------------------

close all; clc; clearvars;


%% Configuration

cfg.case        = "tnbl";                                                  % "sbl" | "tnbl" | "channelflow" | ...
cfg.t_end       = 90000;                                                   % [s] total simulated time
cfg.t_avg       = 600;                                                     % [s] averaging window
cfg.model       = "stdke";                                                 % turbulence model
cfg.params      = [0.09, 1.44, 1.92, 1.0, 1.0, 1.3];                       % model coefficients

% Debug & output toggles
DEBUG_TIMING    = true;                                                    % flip false to silence timers
SAVE_VARS       = false;                                                   % flip true to save outputs

% Saving options
cfg.out_dir     = "./data/scm";
cfg.Gx          = 12;
cfg.z0          = 0.1;


%% Run case

% % Timer start
t_call = Debug.dbg_tic(DEBUG_TIMING, sprintf('scm_run(%s)', cfg.case));

% Run single column model with specified cfg
[settings, params, avgVars, tsVars] = Core.scm_run(cfg.case, cfg.t_end, cfg.t_avg, cfg.model, cfg.params);

% % Timer end
Debug.dbg_toc(t_call, DEBUG_TIMING);


%% Save outputs

if SAVE_VARS
    if ~isfolder(cfg.out_dir), mkdir(cfg.out_dir); end
    matFile = IO.save_outputs(cfg.out_dir, cfg.case, cfg.model, cfg.Gx, cfg.z0, ...
                          settings, params, avgVars, tsVars, ...
                          'IncludeTimestamp', true);
end


%% (Examples) Alternate options in configuration
%{
% Different model/params:
% cfg.model  = "stdke"; cfg.params = [0.09, 1.44, 1.92, 1.0, 1.0, 1.3];
% cfg.model  = "mostke"; cfg.params = [0.03, 1.21, 1.92, 1.0, 1.3];
% cfg.model  = "de85ke"; cfg.params = [0.40, 1.13, 1.90, 1.0, 0.0013, 0.74, 1.3];
% cfg.model  = "rngke"; cfg.params = [0.0845, 1.42, 1.68, 1.0, 0.7194, 0.7194, 4.38, 0.012];
%
% Different problem cases:
% cfg.case   = "tnbl"; cfg.t_end = 90000; cfg.t_avg = 600;
% cfg.case   = "sbl"; cfg.t_end = 29400; cfg.t_avg = 600;
%}
