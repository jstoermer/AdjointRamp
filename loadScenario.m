function out = loadScenario(json)
%% json is either a filename or already loaded struct

%% if json.type = 1, then json was serialized from matlab struct, 
% not created by hand, and is therefore more straight forward to initialize

%% structure of output:
%       scen.links:    1xN struct
%             link:    v,w,fm,rmax,L
%          scen.BC:    D, beta -> T x N matrix
%          scen.IC:    l0, p0 -> 1 x N matrix
%           scen.N:    1 x 1 matrix, number of mainlines
%           scen.T:    1 x 1 matrix, number of demand points specified

%% format of json
%                             dt:   1 x 1
%                        beta, D:   T x N
%   L, p0, l0, p, v, w, fm, rmax:   1 x N
%

json = jsonOrFilename(json);

%% in case json is lazily dumped
if isfield(json,'type') && json.type == 1
    out = json.scen;
    return;
end

data = json;
N = length(data.v);
T = size(data.D,1);

%% create links
links.w(N) = 0;links.v(N) = 0;links.fm(N) = 0;links.p(N) = 0; % preallocate
for i = 1:N    
    links(i).v = data.v(i);
    links(i).w = data.w(i);
    links(i).fm = data.fm(i);
    links(i).p = data.p(i);
    links(i).rmax = data.rmax(i);
    links(i).L = data.L(i);
end

%% initial conditions
IC.l0 = data.l0;
IC.p0 = data.p0;

%% boundary conditions
BC.D = data.D;

% allows lazy repeat of beta
if size(data.beta,1) == 1
    beta = repmat(data.beta,T,1);
else
    beta = data.beta;
end
BC.beta = beta;

%% scenario
scen.links = links;
scen.BC = BC;
scen.IC = IC;
scen.N = N;
scen.T = T;
scen.dt = data.dt;

out = scen;
end