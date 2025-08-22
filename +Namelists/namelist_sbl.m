function settings = namelist_sbl()
%NAMELISTS.NAMELIST_SBL  Settings for the SBL case.

settings = struct();

% Case
settings.casename = "sbl";                                                 % Problem case

% Time
settings.timestep = "rk4";                                                 % Time integration scheme
settings.dt = 1.0;                                                         % Time increment [s]
settings.start_time = 1;                                                   % Start time [s]
settings.end_time = 2;                                                     % Finish time [s]

% Domain
settings.Lz = 400;                                                         % Domain height [m]   
settings.nz = 64;                                                          % Grid points [-]
settings.zEdge = linspace(0,settings.Lz,settings.nz+1);                    % Grid edges [m]
settings.zCell = 0.5*(settings.zEdge(2:end) + settings.zEdge(1:end-1));    % Grid mid-cells [m]
settings.dz = settings.zCell(2) - settings.zCell(1);                       % Grid size [m]  

% Physics
settings.Gx = 8;                                                           % Geostrophic wind u-component [m/s]   
settings.Gy = 0;                                                           % Geostrophic wind v-component [m/s]
settings.phi = 73;                                                         % Latitude [deg]
settings.lambda = 40;                                                      % Neutral lengthscale [m]
settings.Omega = 7.29*10^-5;                                               % Angular speed of Earth [rad/s]
settings.f = 2 * settings.Omega * sind(settings.phi);                      % Coriolis parameter [-]
settings.z0 = 0.1;                                                         % Roughness length for momentum [m]
settings.z0H = settings.z0;                                                % Roughness length for heat [m]
settings.Pr_t = 0.85;                                                      % Turbulent Prandtl number [-] 
settings.g = 9.81;                                                         % Gravitational acceleration [m/s^2]
settings.kappa = 0.40;                                                     % von Karman constant [-]
settings.potT0 = 263.5;                                                    % Reference potential temperature [K]
settings.l_m = settings.kappa*settings.zCell./(1 + settings.kappa*settings.zCell/settings.lambda);    % Turbulent mixing length (Blackadar, 1962)
settings.coolingrate = -0.25;                                              % Surface cooling rate [K/h]
settings.potTs = 265;                                                      % Reference surface potential temperature [K]

% Stability
settings.A = 4.8;                                                          % Constant in stability formulation for momentum [-]
settings.B = 7.8;                                                          % Constant in stability formulation for heat [-]
settings.L = Inf;                                                          % Obukhov length [m]
settings.zeta = settings.zCell/settings.L;                                 % Stability parameter [-]
settings.psi_M = - settings.A*settings.zeta;                               % Stability correction for momentum [-] (stable only)
settings.psi_H = - settings.B*settings.zeta;                               % Stability correction for heat [-] (stable only)
settings.phi_M = 1 + settings.A*settings.zeta;                             % Stability function for momentum [-] (stable only)
settings.phi_H = 1 + settings.B*settings.zeta;                             % Stability function for heat [-] (stable only)
settings.phi_E = settings.phi_M - settings.zeta;                           % Normalized turbulent dissipation rate [-] (stable only)

% Other
settings.sponge = 0.1;                                                     % Sponge region
settings.turb_model = "stdke";                                             % Turbulence model

end