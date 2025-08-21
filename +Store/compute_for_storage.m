function [settings, uw, vw, wT, nu_t, alpha_t, ablh] = compute_for_storage( ...
    settings, params, u, v, T, k, e, ustar, uw_surf, vw_surf, wT_surf)
%COMPUTE_FOR_STORAGE: Computes stresses for storage

% Eddy viscosity/diffusivity
[nu_t, alpha_t] = TurbMod.eddyviscosity(settings, params, k, e); 

z = settings.zCell(:);

% Fluxes
uw = -nu_t .* FD.CDS2_1(z, u);  uw(1) = uw_surf;
vw = -nu_t .* FD.CDS2_1(z, v);  vw(1) = vw_surf;
wT = -alpha_t .* FD.CDS2_1(z, T); wT(1) = wT_surf;

% ABL height: first z where tau < 5% of surface stress
tau_mag = hypot(uw, vw);          
thr     = 0.05 * (ustar^2);
idx     = find(tau_mag < thr, 1, 'first');
if isempty(idx), idx = numel(z); end
ablh = z(idx);

end
