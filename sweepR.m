function [outputStruct] = sweepR(scenFile, X1, X2, N)

% The cost of N logarithmically equally spaced R-values, between decades
% 10^X1 and 10^X2, is computed and the results are plotted.

R = logspace(X1, X2, N);
outputStruct = [];

global parameters;

for i = 1:N
    % disp(i);
    parameters.R = R(i);
    [u, outputState, totCost] = rampOptimalU(scenFile);
    myVariable = struct('Name', 'R-Value', 'Value', R(i));
    currTrial = struct('Variable', myVariable, 'Cost', totCost(end), ...
        'u', u, 'OutputState', outputState);
    outputStruct = [outputStruct, currTrial];
end % end for i = 1:N

end % end sweepR