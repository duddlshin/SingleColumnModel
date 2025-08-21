%% Single-Column Model - Main
% Author: Ethan YoungIn Shin
% Last modified: 2025-08-21
% -------------------------------------------------------------

close all; clc; clearvars;


%% Bootstrap: run startup if needed (or if we're inside scripts/)

here     = mfilename('fullpath');
thisDir  = fileparts(here);
[parentDir, leaf] = fileparts(thisDir);

% project root = parent of scripts/ (if we're in scripts), else thisDir
if strcmpi(leaf, 'scripts')
    proj = parentDir;
else
    proj = thisDir;
end

need_startup = strcmpi(leaf,'scripts') || ~exist('Init.initialize_profiles','file');

if need_startup
    sfile = fullfile(proj, 'startup.m');
    if exist(sfile, 'file')
        run(sfile);          % adds root + any non-package folders
    else
        addpath(proj);       % fallback so +packages resolve
    end
end

clear here thisDir parentDir leaf proj sfile need_startup


%% Configuration

cfg.case        = "tnbl";                          % "sbl" | "tnbl" | "channelflow" | ...
cfg.t_end       = 90000;                          % [s] total simulated time
cfg.t_avg       = 600;                            % [s] averaging window
cfg.model       = "stdke";                       % turbulence model
cfg.params      = [0.09, 1.44, 1.92, 1.0, 1.0, 1.3];   % model coefficients

% Debug & output toggles
DEBUG_TIMING    = true;                           % flip false to silence timers

% Saving options
cfg.out_dir     = "./data";
cfg.Gx          = 8;
cfg.z0          = 0.1;


%% Run case

% % Timer start
t_call = Debug.dbg_tic(DEBUG_TIMING, sprintf('scm_run(%s)', cfg.case));

% Run single column model with specified cfg
[settings, params, avgVars, tsVars] = Core.scm_run(cfg.case, cfg.t_end, cfg.t_avg, cfg.model, cfg.params);

% % Timer end
Debug.dbg_toc(t_call, DEBUG_TIMING);


%% Save outputs

SAVE_VARS       = false;                          % flip true to save outputs

if SAVE_VARS
    if ~isfolder(cfg.out_dir), mkdir(cfg.out_dir); end
    matFile = IO.save_outputs(cfg.out_dir, cfg.case, cfg.model, cfg.Gx, cfg.z0, ...
                          settings, params, avgVars, tsVars, ...
                          'IncludeTimestamp', true);
end


%% (Examples) Alternate runs — kept as ready-to-uncomment
%{
% TNBL:
% cfg.case   = "tnbl"; cfg.t_end = 90000; cfg.t_avg = 600;
% [params, outputs, ts_outputs] = scm_run(cfg.case, cfg.t_end, cfg.t_avg, cfg.model, cfg.params);

% Different model/params:
% cfg.model  = "stdke"; cfg.params = [0.09, 1.44, 1.92, 1.0, 1.0, 1.3];
% [params, outputs, ts_outputs] = scm_run(cfg.case, cfg.t_end, cfg.t_avg, cfg.model, cfg.params);
%}
