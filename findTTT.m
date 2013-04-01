function TTT = findTTT(scen, states, u)
% PURPOSE:
% Calculates the total travel time (TTT) for a scenario. The TTT is given
% by the following: objCost + sum(uPenalty).
%
% INPUTS:
% 1. scen: A scenario, given in the JSON format.
% 2. states: A struct containing the results of a forward simulation.
% 3. u: Optimal ramp metering control.
%
% OUPUTS:
% 1. TTT: The TTT for the scenario. The equation for TTT is given in the 
%         PURPOSE.

objCost = findObjective(scen, states);
TTT = objCost + sum(sum(uPenalty(scen, states.queue, u)));

end % end findObjective