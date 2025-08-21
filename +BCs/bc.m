function [settings,u,v,T,k,e,ustar,uw_surf,vw_surf,wT_surf] = bc(settings,params,u,v,T,k,e,i)
% Function to implement boundary conditions (BCs)

% Algorithm switch
switch string(settings.casename)
    case {"tnbl", "channelflow"}
        % SURFFLUX1, Basu 2008
        U = sqrt(u(1)^2 + v(1)^2);
        ustar = (U*settings.kappa)/(log(settings.zCell(1)/settings.z0) - settings.psi_M(1));
        wT_surf = 0;
        settings.L = Inf;
    case {"sbl"}
        % SURFFLUX2, Basu 2008
        T(1) = 265 + settings.coolingrate*i*settings.dt/3600;   
        U = sqrt(u(1)^2 + v(1)^2);
        ustar = (U*settings.kappa)/(log(settings.zCell(1)/settings.z0) - settings.psi_M(1));
        delta_T = T(2) - T(1);
        wT_surf = - delta_T * ustar * settings.kappa / (log(settings.zCell(1)/settings.z0H) - settings.psi_H(1));
        settings.L = - settings.potT0 * ustar^3 / (settings.kappa * settings.g * wT_surf);
    otherwise
        warning("Not a valid problem case.");
        return
end

% Update stability functions
settings.zeta = settings.zCell/settings.L;
settings.psi_M = - settings.A*settings.zeta;
settings.psi_H = - settings.B*settings.zeta;
settings.phi_M = 1 + settings.A*settings.zeta;
settings.phi_H = 1 + settings.B*settings.zeta; 
settings.phi_E = settings.phi_M - settings.zeta;

% Lower BCs
% Shear stress components
uw_surf = -(ustar^2)*(u(1)/U);
vw_surf = -(ustar^2)*(v(1)/U);
% Turbulence variables
k(1) = ustar^2 / sqrt(params.C_mu);
e(1) = ustar^3 / (settings.kappa * settings.zCell(1));

% Upper BCs
u(end) = settings.Gx;
v(end) = settings.Gy;
k(end) = 0;
e(end) = 0;

% % (Sponge region)
% u(round(settings.nz*(1-settings.sponge)):end) = settings.Gx;
% v(round(settings.nz*(1-settings.sponge)):end) = settings.Gy;
% % k(round(settings.nz*(1-settings.sponge)):end) = 0;
% if settings.casename == "sbl"
%     T(round(settings.nz*(1-settings.sponge)):end) = 265 + 0.01*(settings.zCell(round(settings.nz*(1-settings.sponge)):end) - 100); 
% elseif settings.casename == "tnbl"
%     T(round(settings.nz*(1-settings.sponge)):end) = 300;
% end

end