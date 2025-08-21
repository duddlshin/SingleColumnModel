function [dkdt,dedt] = rngke(settings, params, S)
%RNGKE: RNG k-epsilon formulation of dkdt, dedt
% Reference: Yakhot & Orszag, 1986

% RHS in prognostic equation for TKE dissipation rate
T_e = FD.CDS2_1(settings.zCell, S.nu_t/params.sig_e) .* S.dedz + (S.nu_t/params.sig_e) .* FD.CDS2_2(settings.zCell, S.e);
D_e = (S.e.^2)./S.k; D_e(S.k == 0) = 0;
S_temp = sqrt(S.dudz.^2 + S.dvdz.^2); eta = S_temp.*k./S.e; eta(S.e==0) = 0;
C_2_star = params.C_2 + (params.C_mu*(eta.^3).*(1 - eta./params.eta_0))./(1 + params.beta*eta.^3);

% dkdt, dedt
dkdt = S.P_s + S.P_b + S.T_k - S.e;
dedt = params.C_1*(S.e./S.k).*S.P_s + params.C_3*(S.e./S.k).*S.P_b - C_2_star.*D_e + T_e; dedt(S.k==0) = 0;

end