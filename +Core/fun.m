function [dudt,dvdt,dTdt,dkdt,dedt] = fun(settings,params,u,v,T,k,e,uw_surf,vw_surf,ustar)

% Locals 
z   = settings.zCell(:);

% Physical constraints
k = max(k,0); 
e = max(e,0);

% Eddy viscosity/diffusivity
[nu_t, alpha_t] = TurbMod.eddyviscosity(settings, params, k, e);

% Gradients
dudz = FD.CDS2_1(z, u);    
dvdz = FD.CDS2_1(z, v);
dTdz = FD.CDS2_1(z, T);    
dkdz = FD.CDS2_1(z, k);
dedz = FD.CDS2_1(z, e);

% Fluxes (apply bottom BCs)
uw = -nu_t .* dudz; uw(1) = uw_surf; uw(end) = 0;
vw = -nu_t .* dvdz; vw(1) = vw_surf; vw(end) = 0;
wT = -alpha_t .* dTdz; wT(1) = 0; wT(end) = 0;

% Reynolds-stress and heat terms
gradRx = FD.CDS2_1(z, uw);
gradRy = FD.CDS2_1(z, vw);
gradT  = - FD.CDS2_1(z, alpha_t) .* dTdz - alpha_t .* FD.CDS2_2(z, T);

% Governing equations: u, v, T
dudt = settings.f * (v - settings.Gy) - gradRx;
dvdt = settings.f * (settings.Gx - u) - gradRy;
dTdt = - gradT;

% Shear production, buoyancy, diffusion terms
P_s = -uw.*dudz - vw.*dvdz;
P_b = (settings.g/settings.potT0) .* (-alpha_t .* dTdz);
T_k = FD.CDS2_1(z, nu_t/params.sig_k) .* dkdz + (nu_t/params.sig_k) .* FD.CDS2_2(z, k);

% Pack shared context for model-specific prognostic equations
S = struct('k',k,'e',e,'nu_t',nu_t,'alpha_t',alpha_t, ...
           'dkdz',dkdz,'dedz',dedz,'P_s',P_s,'P_b',P_b,'T_k',T_k, ...
           'ustar',ustar,'z',z);

% Dispatch turbulence-model RHS
switch string(settings.turb_model)
    case "stdke"
        [dkdt,dedt] = TurbMod.stdke(settings, params, S);
    case "mostke"
        [dkdt,dedt] = TurbMod.mostke(settings, params, S);
    case "rngke"
        [dkdt,dedt] = TurbMod.rngke(settings, params, S);
    case "de85ke"
        [dkdt,dedt] = TurbMod.de85ke(settings, params, S);
    otherwise
        error('fun:BadModel','Unsupported turb_model: %s', string(settings.turb_model));
end

end
