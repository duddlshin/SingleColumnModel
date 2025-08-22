function matFile = save_outputs(outdir, casename, turb_model, Gx, z0, ...
                                settings, params, avgVars, tsVars, varargin)
%SAVE_OUTPUTS: Save SCM outputs with a consistent filename.
%   matFile = IO.save_outputs(outdir, casename, turb_model, G, z0, ...
%                             settings, params, avgVars, tsVars, ...
%                             'IncludeTimestamp', true, 'MatVersion','-v7.3')
%
% - outdir      : folder to write into (created if missing)
% - casename    : e.g. "sbl", "tnbl", "channelflow"
% - turb_model  : e.g. "mostke", "stdke"
% - G, z0       : geostrophic wind & roughness length
% - settings    : run settings struct
% - params      : model params struct
% - avgVars     : time-averaged variables struct
% - tsVars      : time-series variables struct
%
% Returns: full path to the saved .mat file

% -------- options --------
p = inputParser;
p.addParameter('IncludeTimestamp', true,  @(x)islogical(x) || isnumeric(x));
p.addParameter('MatVersion',      '-v7.3', @(x)ischar(x) || isstring(x));  % use -v7.3 for large arrays
p.parse(varargin{:});
opt = p.Results;

% ensure folder
if ~isfolder(outdir)
    mkdir(outdir);
end

% filename tokens
caseTok = char(casename);
modelTok = char(turb_model);
Gtok  = num2tok(Gx);     % e.g. 8    -> "8"
z0tok = num2tok(z0);    % e.g. 0.1  -> "0p1"

fname = sprintf('case-%s_model-%s_Gx-%s_z0-%s', caseTok, modelTok, Gtok, z0tok);
if opt.IncludeTimestamp
    fname = sprintf('%s_%s', fname, datestr(now, 'yyyymmdd_HHMMSS'));
end
matFile = fullfile(outdir, [fname '.mat']);

% payload (single top-level struct)
run = struct();
run.meta = struct( ...
    'case',      casename, ...
    'model',     turb_model, ...
    'G',         Gx, ...
    'z0',        z0, ...
    'created_at', datetime('now'), ...
    'mat_version', string(opt.MatVersion) ...
);
run.settings = settings;
run.params   = params;
run.avg      = avgVars;
% run.ts       = tsVars; % this increases memory quite a bit

% save
save(matFile, 'run', opt.MatVersion);
fprintf('[save_outputs] Wrote %s\n', matFile);

end

% helpers
function s = num2tok(x)
% Make a filename-safe token for a scalar number
s = sprintf('%g', x);
s = regexprep(s, '^-', 'm');    % leading minus -> m
s = strrep(s, '+',  '');        % drop plus
s = strrep(s, '.',  'p');       % dot -> p
end
