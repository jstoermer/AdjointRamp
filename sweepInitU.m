function [outputStruct] = sweepInitU(varargin)
% Inputs:
% varargin(1) - JSON description of a scenario.
% Either: varargin(2) - Number of trials,
% Or: varargin(2,3,...) - Matrices of various initial u-values. 
% If the number of trials are provided, matrices of various initial
% u-values will be generated, ranging from a matrix of zeros to a matrix of
% no control.

scenFile = varargin{1};
myScenario = io.loadScenario(scenFile);
varargin(1) = [];

if length(varargin{1}) == 1
    numTrials = varargin{1};
    initU = cell(1, numTrials);
    myNoControlU = noControlU(myScenario);
    for i = 1:numTrials
        initU{i} = myNoControlU .* (i - 1)/(numTrials - 1);
    end % end for i = 1:numTrials
else  
    numTrials = length(varargin);
    initU = cell(1, numTrials);
    for i = 1:numTrials
        initU{i} = varargin(i);
    end % end for i = 1:numU
end % end if length(varargin == 1)

outputStruct = [];

for i = 1:length(initU)
    [u, outputState, totCost] = rampOptimalU(scenFile, initU{i});
    myVariable = struct('Name', 'Initial u-Value', 'Value', initU{i});
    currTrial = struct('Variable', myVariable, 'Cost', totCost(end), ...
        'u', u, 'OutputState', outputState);
    outputStruct = [outputStruct, currTrial];
end % end for i = 1:length(initU)

end % end sweepInitU