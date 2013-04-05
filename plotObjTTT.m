function [objCost, optObjCost, TTT, optTTT] = plotObjTTT(varargin)
% PURPOSE:
% Plots the objective costs and total travel times for a scenario, with a
% varying amount of time steps.
%
% INPUTS:
% 1. jsonScen: A scenario, provided in the JSON format.
% 2. (Optional) numTrials: The amount of trials to be plotted. If not
%    provided, numTrials will default to 5. Each trial will increase the
%    amount of time steps by 25.
%
% OUTPUTS:
% 1. objCost: An array of the objective costs.
% 2. optObjCost: An array of the objective costs for the optimized network.
% 3. TTT: An array of the total travel times.
% 4. optTTT: An array of the total travel times for the optimized network.

jsonScen = varargin{1};

if length(varargin) > 1
    numTrials = varargin{2};
else
    numTrials = 5;
end % end if

numTimeSteps = zeros(1, numTrials);
objCost = zeros(1, numTrials);
optObjCost = zeros(1, numTrials);
TTT = zeros(1, numTrials);
optTTT = zeros(1, numTrials);

initTimeSteps = jsonScen.T;

for i = 1:numTrials
    numTimeSteps(i) = initTimeSteps + 25*(i - 1);
    if i > 1
        jsonScen = extendScenario(jsonScen, 25);
    end % end if
    u = noControlU(jsonScen);
    optU = rampOptimalU(jsonScen);
    outState = forwardSimulation(jsonScen, u);
    optOutState = forwardSimulation(jsonScen, optU);
    objCost(i) = findObjective(jsonScen, outState, u);
    optObjCost(i) = findObjective(jsonScen, optOutState, optU);
    TTT(i) = findTTT(jsonScen, outState);
    optTTT(i) = findTTT(jsonScen, optOutState);
end % end for

objCost = fixInfVal(objCost);
optObjCost = fixInfVal(optObjCost);
TTT = fixInfVal(TTT);
optTTT = fixInfVal(optTTT);

plot(numTimeSteps, objCost, 'o-', numTimeSteps, optObjCost, 'o-', numTimeSteps, TTT, 'o-', numTimeSteps, optTTT, 'o-');
legend('Objective Cost, Before Optimization', 'Objective Cost, After Optimization', 'Total Travel Time, Before Optimization', 'Total Travel Time, After Optimization', 'Location', 'Northwest');
title('Objective Costs and Travel Times');
ylabel('Cost');
xlabel('Number of Time Steps');

end % end plotObjTTT