% Data to debug
load('data/debug/tsVars_FAIL_case-sbl_model-mostke_Gx-8_z0-0p1_nonfinite_i012185.mat')

% Animation to visualize data failure
mov = Debug.dbg_animate(tsVars.u, settings.zCell, 'Step', 300, 'FPS', 20, ...
                        'SaveVideo', false, 'Filename', 'profile.mp4', ...
                        'Figure', 2, 'LineWidth', 2);