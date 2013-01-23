function [outputStruct] = sweepR(scenFile, X1, X2, N)

% The cost of N logarithmically equally spaced R-values, between decades
% 10^X1 and 10^X2, is computed and the results are plotted.

R = logspace(X1, X2, N);
myCost = zeros(1, N);
outputStruct = [];

global parameters;

for i = 1:N
    parameters.R = R(i);
    [u, outputState, totCost] = rampOptimalU(scenFile);
    myVariable = struct('Name', 'R-Values', 'Value', R(i));
    currTrial = struct('Variable', myVariable, 'Cost', totCost(end), ...
        'u', u, 'OutputState', outputState);
    outputStruct = [outputStruct, currTrial];
end % end for i = 1:N

for i = 1:length(outputStruct)
    myCost(i) = outputStruct(i).Cost;
end % end for i = 1:size(outputStruct)

% semilogx(R, myCost);
% title('Cost vs. \it{R}\rm-Value');
% xlabel('\it{R}\rm-Value');
% ylabel('Cost');

end % end sweepR