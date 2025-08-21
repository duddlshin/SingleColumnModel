function Store = make_storage(settings, ~, save_every, include_t0)
%MAKE_STORAGE: Preallocate storage for time history.
%
%   settings.nz      : number of vertical points
%   settings.dt      : time step
%   settings.end_time: total simulated time
%
%   save_every: store every k-th time step
%   include_t0: if true, also store initial state at t=0

if nargin < 3 || isempty(save_every), save_every = 1;   end
if nargin < 4 || isempty(include_t0), include_t0 = true; end

Nz = settings.nz;
Nt_full = floor(settings.end_time / settings.dt); 
Nt = floor(Nt_full / save_every) + double(include_t0);

Z  = @(m) zeros(m, Nt, 'double');   
Z1 = @()  zeros(1, Nt, 'double');   

Store.u      = Z(Nz);
Store.v      = Z(Nz);
Store.T      = Z(Nz);
Store.k      = Z(Nz);
Store.e      = Z(Nz);
Store.ustar  = Z1();
Store.uw     = Z(Nz);
Store.vw     = Z(Nz);
Store.wT     = Z(Nz);
Store.nu_t   = Z(Nz);
Store.alpha_t= Z(Nz);
Store.ablh   = Z1();
Store.L      = Z1();

end