function out = unstack(varargin)
u = varargin{1};
if nargin == 2
  scen = varargin{2};
  n = scen.N;
  t = scen.T;
else
  n = varargin{2};
  t = varargin{3};
end
out = reshape(u, n , t)';
end