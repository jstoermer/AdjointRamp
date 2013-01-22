function [] = sweepR(scenFile, initR, numTrials)

% initR is the starting value for r. For each trial, r is multiplied by 10.
% e.g. initR = 0.01, numTrials = 3 gives trials with r = 0.01, 0.1, 1.

r = zeros(1, numTrials);
cost = zeros(1, numTrials);

global parameters;
scen = io.loadScenario(scenFile);
u0 = chooseInitialU(scen);
descent = parameters.globalDescentAlgorithm;
s = rampAdjointStructures(scen);

for i = 1:numTrials
    parameters.R = initR * 10^(i - 1);
    [u, totCost] = adjointOptimization(scen, stacker(u0), s.state, s.cost, s.dhdx, s.djdx, s.dhdu, s.djdu, descent);
    r(i) = parameters.R;
    
    % Do we want the sum of the costs?
    cost(i) = sum(totCost);
    
    % Or the final cost?
    % cost(i) = totCost(end);
    
end % end for i = 1:numTrials

semilogx(r, cost);
title('Cost vs. \it{r}\rm-Value');
xlabel('\it{r}\rm-Value');
ylabel('Cost');

end % end sweepR