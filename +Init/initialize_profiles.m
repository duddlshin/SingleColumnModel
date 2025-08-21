function [settings, u, v, T, k, e] = initialize_profiles(settings, params)
%INITIALIZE_PROFILES: Initialization of u, v, T, k, e.
% Returns column vectors of length nz.

% Locals 
z   = settings.zCell(:);
nz  = settings.nz;
one = ones(nz,1,'like',z);     

Gx = settings.Gx;
Gy = settings.Gy;

switch string(settings.casename)
    case "tnbl"
        % Velocity components
        u = Gx * one;
        v = Gy * one;
        % Potential temperature 
        T = 300 * one;
        % TKE
        k = 0.4*(1 - z./250).^3; k(z > 250) = 0; 

    case "sbl"
        % Velocity components
        u = Gx * one;
        v = Gy * one;
        % Potential temperature
        T = 265 + 0.01 * max(z - 100, 0);
        % TKE
        k = 0.4*(1 - z./50).^3; k(z > 50) = 0; 
        
    case "channelflow"
        % Log-law velocity
        u = (1/settings.kappa)*log(z/settings.z0);
        v  = zeros(nz,1,'like',z);
        % Potential temperature not used in neutral channel
        T  = zeros(nz,1,'like',z);
        % TKE 
        k = 0.4*(1 - z./(z(end)/3)).^3; k(z > (z(end)/3)) = 0;

    otherwise
        error('Unknown casename: %s', string(settings.casename));
end

% TKE dissipation rate profile for k-epsilon family
e = params.C_mu^(3/4) * (k .* sqrt(k)) ./settings.l_m(:);        

% MOST stability function placeholders
settings.psi_M = 0;
settings.psi_H = 0;
settings.phi_M = 0;
settings.phi_H = 0;

end
