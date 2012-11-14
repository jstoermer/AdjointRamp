function u = chooseInitialU(varargin)
global parameters;
scen = varargin{1};
if nargin == 2
  factor = varargin{2};
else
  factor = parameters.defaultUScale;
end


T = scen.T;
N = scen.N;

u = zeros(T,N);

for n = 1:N
    u(:, n) = scen.links(n).rmax* factor;
end
end
