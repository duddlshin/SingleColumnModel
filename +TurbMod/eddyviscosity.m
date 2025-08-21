function [nu_t, alpha_t] = eddyviscosity(settings, params, k, e)
%EDDYVISCOSITY: eddy viscosity/diffusivity formulation
% Currently supports: "stdke", "mostke", "rngke", "de85ke"

% Turbulence model switch
switch string(settings.turb_model)
    case {"stdke", "mostke", "rngke", "de85ke"}
        inv_e = 1 ./ e;
        nu_t  = params.C_mu .* (k .* k) .* inv_e;
        nu_t(isnan(nu_t)|isinf(nu_t)) = 0;
    otherwise
        warning("Not a valid turbulence model.");
        return
end

% Eddy diffusivity for heat
alpha_t = nu_t ./ settings.Pr_t;
end
