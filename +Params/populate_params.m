function params = populate_params(turb_model)
%POPULATE_PARAMS: Populate with default parameters
% Currently supports: "stdke", "mostke", "de85ke", "rngke"

% Turbulence model switch
switch string(turb_model)
    case {"stdke"}
        % Standard k-epsilon model (Launder & Spalding, 1974)
        params.C_mu = 0.09;
        params.C_1 = 1.44;     
        params.C_2 = 1.92;      
        params.C_3 = 1.0;
        params.sig_k = 1.0;
        params.sig_e = 1.3;
    case {"mostke"}
        % MOST k-epsilon model (van der Laan et al., 2017)
        params.C_mu = 0.03;
        params.C_1 = 1.21;     
        params.C_2 = 1.92;  
        params.sig_k = 1.0;
        params.sig_e = 1.3;
    case {"de85ke"}
        % Proposed ABL k-epsilon model (Detering & Etling, 1985)
        params.C_0 = 0.40;
        params.C_1 = 1.13;     
        params.C_2 = 1.90;
        params.C_3 = 1.0;
        params.C_e = params.C_0^3;
        params.C_mu = params.C_0^4;
        params.C_h = 0.0013;
        params.sig_k = 0.74;
        params.sig_e = 1.3;
    case {"rngke"}
        % Renormalization group k-epsilon model (Yakhot & Orszag, 1986)
        params.C_mu = 0.0845;
        params.C_1 = 1.42;     
        params.C_2 = 1.68; 
        params.C_3 = 1.0;
        params.sig_k = 0.7194;
        params.sig_e = 0.7194;
        params.eta_0 = 4.38;
        params.beta = 0.012;
    otherwise
        warning("Not a valid turbulence model.");
        return
end

end