function avgVars = time_average(settings, tsVars)

% Define indices
dt   = settings.dt;
Nt   = size(tsVars.u, 2);               % assumes all stores share Nt
t1   = max(0, settings.start_time);      % [s]
t2   = min(settings.end_time, Nt*dt);    % [s]

i1   = max(1, floor(t1/dt) + 1);       % inclusive
i2   = min(Nt, floor(t2/dt));          % inclusive
if i2 < i1, error('Empty averaging window.'); end

n    = i2 - i1 + 1;                    % number of samples
w    = ones(n,1,'like',tsVars.u) / n;   % weights 
idx  = i1:i2;

% Define averaging method
avg  = @(A) A(:, idx) * w;

% Means
avgVars.u_mn       = avg(tsVars.u);
avgVars.v_mn       = avg(tsVars.v);
avgVars.T_mn       = avg(tsVars.T);
avgVars.k_mn       = avg(tsVars.k);
avgVars.e_mn       = avg(tsVars.e);
avgVars.nu_t_mn    = avg(tsVars.nu_t);
avgVars.alpha_t_mn = avg(tsVars.alpha_t);
avgVars.uw_mn      = avg(tsVars.uw);
avgVars.vw_mn      = avg(tsVars.vw);
avgVars.wT_mn      = avg(tsVars.wT);

end
