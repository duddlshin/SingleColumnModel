% Data to debug
load('data/scm/case-tnbl_model-mostke_Gx-12_z0-0p1_20250821_230706.mat')

% Animation to visualize data
mov = Debug.dbg_animate(tsVars.u, settings.zCell, 'Step', 100, 'FPS', 20, ...
                        'SaveVideo', false, 'Filename', 'profile.mp4', ...
                        'Figure', 2, 'LineWidth', 2);