function [dkdt,dedt] = mostke(settings, params, S)
%MOSTKE: MOST k-epsilon formulation of dkdt, dedt
% Reference: van der Laan et al., 2017

% Shared components
D_e = (S.e.^2)./S.k; D_e(S.k == 0) = 0;

% Locals
zeta = settings.zeta;

% Case switch
switch string(settings.casename)
    case {"tnbl", "channelflow"}
        % RHS in prognostic equation for TKE
        S_k = 0;
        fe = settings.phi_M.^(-5/2) .* (2*settings.phi_M - 1);
        C_3 = (1./zeta).*(settings.phi_M./settings.phi_H).*(params.C_1*settings.phi_M ...
            - params.C_2*settings.phi_E + (params.C_2 - params.C_1)*settings.phi_E.^(-0.5).*fe);  C_3(isnan(C_3)) = 0; C_3 = C_3';
        % RHS in prognostic equation for TKE
        T_e = FD.CDS2_1(settings.zCell, S.nu_t/params.sig_e) .* S.dedz + (S.nu_t/params.sig_e) .* FD.CDS2_2(settings.zCell, S.e);
    case{"sbl"}
        fst = (2 - zeta) - 2*settings.A*zeta.*(1 - 2*zeta + 2*settings.A*zeta);
        C_kD = settings.kappa^2/(params.sig_k*sqrt(params.C_mu));
        
        % RHS in prognostic equation for TKE
        S_k = (S.ustar^3/(settings.kappa*settings.L))*(1 - settings.phi_H./settings.phi_M - (C_kD/4)*settings.phi_M.^(-7/2).*settings.phi_E.^(-3/2).*fst); S_k = S_k';
        % RHS in prognostic equation for TKE dissipation rate
        fe = settings.phi_M.^(-5/2) .* (2*settings.phi_M - 1);
        C_3 = (settings.Pr_t./zeta).*(settings.phi_M./settings.phi_H).*(params.C_1*settings.phi_M - params.C_2*settings.phi_E ...
            + (params.C_2 - params.C_1)*settings.phi_E.^(-0.5).*fe);  C_3(isnan(C_3)) = 0; C_3 = C_3';
        % disp(C_3);
        T_e = (S.ustar^4./(settings.kappa*settings.zCell).^2).*C_kD.*(params.sig_k/params.sig_e).*sqrt(params.C_mu).*sqrt(settings.phi_M).*fe; T_e = T_e';
    otherwise
        warning("Not a valid turbulence model.");
        return
end

% dkdt, dedt
dkdt = S.P_s + S.P_b + S.T_k - S.e - S_k;
dedt = params.C_1*(S.e./S.k).*S.P_s + C_3.*(S.e./S.k).*S.P_b - params.C_2*D_e + T_e;  dedt(S.k==0) = 0;

end