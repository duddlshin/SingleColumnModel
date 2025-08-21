function params = assign_params(turb_model, new_params)
% ASSIGN_PARAMS: Assign new values to target parameters
% Currently supports: "stdke", "mostke", "de85ke", "rngke"

% Turbulence model switch
switch string(turb_model)
    case {"stdke"}
        % Standard k-epsilon model (Launder & Spalding, 1974)
        params.C_mu = new_params(1);
        params.C_1 = new_params(2);    
        params.C_2 = new_params(3);    
        params.C_3 = new_params(4);
        params.sig_k = new_params(5);
        params.sig_e = new_params(6);
    case {"mostke"}
        % MOST k-epsilon model (van der Laan et al., 2017)
        params.C_mu = new_params(1);
        params.C_1 = new_params(2);    
        params.C_2 = new_params(3);    
        params.sig_k = new_params(4);
        params.sig_e = new_params(5);
    case {"de85ke"}
        % Proposed ABL k-epsilon model (Detering & Etling, 1985)
        params.C_0 = new_params(1);
        params.C_1 = new_params(2);     
        params.C_2 = new_params(3);  
        params.C_3 = new_params(4);  
        params.C_e = params.C_0^3;
        params.C_mu = params.C_0^4;
        params.C_h = new_params(5);
        params.sig_k = new_params(6);
        params.sig_e = new_params(7);
    case {"rngke"}
        % Renormalization group k-epsilon model (Yakhot & Orszag, 1986)
        params.C_mu = new_params(1);
        params.C_1 = new_params(2);    
        params.C_2 = new_params(3);
        params.C_3 = new_params(4);
        params.sig_k = new_params(5);
        params.sig_e = new_params(6);
        params.eta_0 = new_params(7);
        params.beta = new_params(8);
    otherwise
        warning("Not a valid turbulence model.");
        return
end

end