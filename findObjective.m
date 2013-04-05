function objCost = findObjective(scen, states, u)
% PURPOSE:
% Calculates the objective costs for a scenario. The objective cost is 
% given by the following: TTT + sum(uPenalty).
%
% INPUTS:
% 1. scen: A scenario, given in the JSON format.
% 2. states: A struct containing the results of a forward simulation.
% 3. u: Optimal ramp metering control.
%
% OUPUTS:
% 1. objCost: The objective cost for the scenario. The equation for 
%    objective cost is given in the PURPOSE.

TTT = findTTT(scen, states);
objCost = TTT + sum(sum(uPenalty(scen, states.queue, u)));

end % end findObjective