function TTT = findTTT(scen, states)
% PURPOSE:
% Calculates the total travel time (TTT) for a scenario. The TTT is given 
% by the following: (sum(density * length) + sum(queue)) * dt.
%
% INPUTS:
% 1. scen: A scenario, given in the JSON format.
% 2. states: A struct containing the results of a forward simulation.
%
% OUPUTS:
% 1. TTT: The TTT for the scenario. The equation for TTT is given in the 
%    PURPOSE.

L = [scen.links.L]';
rho = states.density;
l = states.queue(1:end - 1, :);
dt = scen.dt;
TTT = (sum(rho * L) + sum(sum(l))) * dt;

end % end findTTT