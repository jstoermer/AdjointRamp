function objCost = findObjective(scen, states)
% PURPOSE:
% Calculates the objective costs for a scenario. The objective cost is
% given by the following: (sum(density * length) + sum(queue)) * dt.
%
% INPUTS:
% 1. scen: A scenario, given in the JSON format.
% 2. states: A struct containing the results of a forward simulation.
%
% OUPUTS:
% 1. objCost: The objective costs for the scenario. The equation for
%    objective cost is given in the PURPOSE.

L = [scen.links.L]';
rho = states.density;
l = states.queue(1:end - 1, :);
dt = scen.dt;
objCost = (sum(rho * L) + sum(sum(l))) * dt;

end % end findObjective