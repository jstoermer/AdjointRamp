function [] = sweepR(scenFile, X1, X2, N)

% The cost of N logarithmically equally spaced R-values, between decades
% 10^X1 and 10^X2, is computed and the results are plotted.

R = logspace(X1, X2, N);
myCost = zeros(1, N);

global parameters;
myScenario = io.loadScenario(scenFile);
initU = chooseInitialU(myScenario);
descentAlg = parameters.globalDescentAlgorithm;
scenStruct = rampAdjointStructures(myScenario);

for i = 1:N
    parameters.R = R(i);
    [u, totCost] = adjointOptimization(myScenario, stacker(initU), ...
        scenStruct.state, scenStruct.cost, scenStruct.dhdx, ...
        scenStruct.djdx, scenStruct.dhdu, scenStruct.djdu, descentAlg);
    myCost(i) = totCost(end);
end % end for i = 1:numTrials

semilogx(R, myCost);
title('Cost vs. \it{R}\rm-Value');
xlabel('\it{R}\rm-Value');
ylabel('Cost');

end % end sweepR