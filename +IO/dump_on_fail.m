function dump_on_fail(tsVars, settings, params, it, reason)
% DUMP_ON_FAIL: Save a debug dump and expose tsVars in base workspace on failure.

try
    % Make a debug folder if it doesn't exist
    outdir = fullfile('.', 'data/debug');
    if ~isfolder(outdir), mkdir(outdir); end

    % Build a filename
    if isfield(settings, 'casename')
        caseTok = char(string(settings.casename));
    else
        caseTok = 'case';
    end
    if isfield(settings, 'turb_model')
        modelTok = char(string(settings.turb_model));
    else
        modelTok = 'model';
    end
    if isfield(settings, 'Gx')
        Gtok  = num2tok(settings.Gx);     % e.g. 8    -> "8"
    else
        Gtok = 'Gx';
    end
    if isfield(settings, 'z0')
        z0tok = num2tok(settings.z0);    % e.g. 0.1  -> "0p1"
    else
        z0tok = 'z0';
    end
    fname  = fullfile(outdir, sprintf('tsVars_FAIL_case-%s_model-%s_Gx-%s_z0-%s_%s_i%06d.mat', ...
        caseTok, modelTok, Gtok, z0tok, reason, it));

    % Save everything you’ll want to inspect later
    save(fname, 'tsVars', 'settings', 'params', 'it', 'reason', '-v7.3');
    fprintf('  ↳ Wrote debug dump: %s\n', fname);
catch ME
    warning('Failed to save debug dump: %s', ME.message);
end

% Also expose in base workspace for immediate inspection
try
    assignin('base', 'tsVars_fail', tsVars);
    assignin('base', 'settings_fail', settings);
    assignin('base', 'params_fail',   params);
    fprintf('  ↳ Variables available in base workspace as tsVars_fail / settings_fail / params_fail\n');
catch ME
    warning('Failed to assign vars to base workspace: %s', ME.message);
end

end


% helpers
function s = num2tok(x)
% Make a filename-safe token for a scalar number
s = sprintf('%g', x);
s = regexprep(s, '^-', 'm');    % leading minus -> m
s = strrep(s, '+',  '');        % drop plus
s = strrep(s, '.',  'p');       % dot -> p
end