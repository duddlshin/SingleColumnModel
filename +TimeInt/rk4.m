function [u,v,T,k,e] = rk4(settings,params,u,v,T,k,e,uw_surf,vw_surf,ustar)
%RK4 Runge-Kutta 4th order method for (u,v,T,k,e)

dt  = settings.dt;
hdt = 0.5*dt;
dt6 = dt/6;

% k1 
[du,dv,dT,dk,de] = Core.fun(settings,params,u,v,T,k,e,uw_surf,vw_surf,ustar);

% Accumulators for weighted sum k1 + 2*k2 + 2*k3 + k4
su = du;  sv = dv;  sT = dT;  sk = dk;  se = de;

% k2
[du,dv,dT,dk,de] = Core.fun(settings,params, ...
    u + hdt*du, v + hdt*dv, T + hdt*dT, k + hdt*dk, e + hdt*de, ...
    uw_surf,vw_surf,ustar);

su = su + 2*du;  sv = sv + 2*dv;  sT = sT + 2*dT;  sk = sk + 2*dk;  se = se + 2*de;

% k3 
[du,dv,dT,dk,de] = Core.fun(settings,params, ...
    u + hdt*du, v + hdt*dv, T + hdt*dT, k + hdt*dk, e + hdt*de, ...
    uw_surf,vw_surf,ustar);

su = su + 2*du;  sv = sv + 2*dv;  sT = sT + 2*dT;  sk = sk + 2*dk;  se = se + 2*de;

% k4 
[du,dv,dT,dk,de] = Core.fun(settings,params, ...
    u + dt*du, v + dt*dv, T + dt*dT, k + dt*dk, e + dt*de, ...
    uw_surf,vw_surf,ustar);

su = su + du;  sv = sv + dv;  sT = sT + dT;  sk = sk + dk;  se = se + de;

% Update 
u = u + dt6*su;
v = v + dt6*sv;
T = T + dt6*sT;
k = k + dt6*sk;
e = e + dt6*se;

% Physical constraints
k = max(k, 0);
e = max(e, 0);
end
