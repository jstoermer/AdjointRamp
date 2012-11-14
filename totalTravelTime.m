function out = totalTravelTime(varargin)
global parameters;
R = parameters.R;
scen = varargin{1};
if nargin == 2
  u = varargin{2};
  states = forwardSimulation(scen, u);
else
  states = varargin{2};
  u = varargin{3};
end

L = [scen.links.L]';
rho = states.density;
l = states.queue(1:end-1,:);
dt = scen.dt;

out = (sum(rho * L) + sum(sum(l)))*dt + sum(sum(3*R.*(max(u - l, 0)).^3));

end

