function [out, outrho, outl, outu] = cost_function(scen)
R = scen.R;
rho = [scen.states.densities];
l = [scen.states.ramp_queues];
l2 = [scen.states(1:end-1).ramp_queues];
u = scen.u';
u = u(:)';
outrho = sum(rho);
outl = sum(l);
outu = R*sum(max(0,u - l2));
out = outrho + outl + outu;
end