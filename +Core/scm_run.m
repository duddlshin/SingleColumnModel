% Function to run SCM
% Input: 
% 1. casename: "sbl" | "tnbl" | "channelflow" | ...
% 2. end_time: [s] total simulated time
% 3. timeavg: [s] averaging window
% 4. turb_model: turbulence model
% 4. new_params: assigned turbulence model parameters
% Outputs: 
% 1. settings: Settings used in the problem case
% 2. params: Assigned turbulence model parameters
% 3. avgVars: time averaged variables [u, v, T, k, e, nu_t, alpha_t, uw, vw, wT]
% 4. tsVars: time series variables [ustar, ablh, L]
function [settings, params, avgVars, tsVars] = scm_run(case_name, end_time, timeavg, turb_model, new_params)

% Input problem case
fname = sprintf('Namelists.namelist_%s', char(case_name));
loc = which(fname);
assert(~isempty(loc), 'Namelist not on path: %s.m', fname);
settings = feval(fname);

% Turbulence model and parameter settings
settings.turb_model = turb_model;                                          % Assign turbulence model
params = Params.assign_params(turb_model, new_params);                     % Assign turbulence model parameters

% Time settings
settings.end_time = end_time;                                              % Assign end time [s]
settings.start_time = settings.end_time - timeavg;                         % Assign start time [s]    
timesteps = 0:settings.dt:settings.end_time;                               % Discretize time
convcriteria = 1e-8;                                                       % Convergence criteria

% Make storage variables
tsVars = Store.make_storage(settings, single(0), 1, true);

% Initialize profiles
[settings,u,v,T,k,e] = Init.initialize_profiles(settings, params);

% Main loop
for i=1:length(timesteps)-1
    % Implement BCs
    [settings,u,v,T,k,e,ustar,uw_surf,vw_surf,wT_surf] = BCs.bc(settings,params,u,v,T,k,e,i);

    % Store QOIs
    [settings,uw,vw,wT,nu_t,alpha_t,ablh] = Store.compute_for_storage(settings,params,u,v,T,k,e,ustar,uw_surf,vw_surf,wT_surf);
    tsVars.u(:,i) = u;
    tsVars.v(:,i) = v;
    tsVars.T(:,i) = T;
    tsVars.k(:,i) = k;
    tsVars.e(:,i) = e;
    tsVars.uw(:,i) = uw;
    tsVars.vw(:,i) = vw;
    tsVars.wT(:,i) = wT;
    tsVars.nu_t(:,i) = nu_t;
    tsVars.alpha_t(:,i) = alpha_t;
    tsVars.ustar(i) = ustar;
    tsVars.ablh(i) = ablh;
    tsVars.L(i) = settings.L;

    % Numerical timestepping
    if settings.timestep=="rk4"
        [u,v,T,k,e] = TimeInt.rk4(settings,params,u,v,T,k,e,uw_surf,vw_surf,ustar);
    end
    
    % Failure guard: NaN/Inf anywhere
    bad = ~all(isfinite(u)) || ~all(isfinite(v)) || ~all(isfinite(T)) ...
        || ~all(isfinite(k)) || ~all(isfinite(e));

    % Check convergence
    if bad
        fprintf('Simulation failed: non-finite detected (NaN/Inf) at step %d.\n', i);
        IO.dump_on_fail(tsVars, settings, params, i, 'nonfinite');
        return;
    elseif i > 1 && i < settings.end_time / settings.dt
        diffu = max(abs(tsVars.u(:,i) - tsVars.u(:,i-1)));
        diffv = max(abs(tsVars.v(:,i) - tsVars.v(:,i-1)));
        if diffu < convcriteria && diffv < convcriteria
            fprintf('Simulation finished. Algorithm has converged at step %d.\n', i);
            IO.dump_on_fail(tsVars, settings, params, i, 'earlystop');
            return;
        end
    elseif i == settings.end_time/settings.dt
        warning('Simulation success: reached final step without early convergence.\n');
    end

end

% Time average variables over assigned averaging window
avgVars = Diagnostics.time_average(settings, tsVars);

end
