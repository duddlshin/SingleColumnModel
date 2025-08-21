function [dkdt,dedt] = de85ke(settings, params, S)
%DE85KE: DE85 k-epsilon formulation of dkdt, dedt
% Reference: Detering & Etling, 1985

% RHS in prognostic equation for TKE dissipation rate
T_e = FD.CDS2_1(settings.zCell, S.nu_t/params.sig_e) .* S.dedz + (S.nu_t/params.sig_e) .* FD.CDS2_2(settings.zCell, S.e);
D_e = (S.e.^2)./S.k; D_e(S.k == 0) = 0;

% dkdt, dedt
dkdt = S.P_s + S.P_b + S.T_k - S.e;
dedt = (params.C_1*params.C_e*settings.f/params.C_h*S.ustar)*(S.k.^0.5).*S.P_s - params.C_2*D_e + T_e;  dedt(k==0) = 0;

end
