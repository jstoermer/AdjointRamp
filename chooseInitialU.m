function u = chooseInitialU(varargin)
scen = varargin{1};
if nargin == 2
  factor = varargin{2};
else
  factor = .5;
end


T = scen.T;
N = scen.N;

u = zeros(T,N);

for n = 1:N
    u(:, n) = scen.links(n).rmax* factor;
end
end
