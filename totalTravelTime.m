function out = totalTravelTime(scen, states, u)
global parameters;
R = parameters.R;
L = [scen.links.L]';
rho = states.density;
l = states.queue(1:end-1,:);
dt = scen.dt;

out = (sum(rho * L) + sum(sum(l)))*dt + sum(sum(3*R.*(max(u - l, 0)).^3));

end

