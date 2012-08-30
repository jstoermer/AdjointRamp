function [out, outrho, outl, outu] = cost_function(scen)
R = scen.R;
rho = [scen.states.densities];
l = [scen.states(2:end).ramp_queues];
u = scen.u';
u = u(:)';
outrho = sum(rho);
outl = sum(l);
outu = sum(max(0,u - l));
out = outrho + outl + outu;
end