function [u, outputState] = optimalU(varargin)
% Computes the optimal ramp metering control for a given scenario
% Inputs
% varargin(1) - JSON description of a scenario or the scenario structure
% varargin(2) - (optional) Initial control
% Outputs
% u - Optimal control 
% outputState - State evolution resulting from the optimal control

scen = jsonOrScen(varargin{1});
try
    u = varargin{2};
catch e
    disp(e);
    u = chooseInitialU(scen);
end

iteration = 0;
while true
    iteration = iteration + 1;
    outputState = forwardSimulation(scen, u);
    gradient = gradientRampControl(scen, outputState, u);
    nextU = nextRampControl(scen, gradient, u);
    if stopIterating(scen, u, nextU, iteration)
        u = nextU;
        return;
    end
    u = nextU;
end

end


function outputState = forwardSimulation(scen, u)
end

function gradient = gradientRampControl(scen, outputState, u)
end

function nextU = nextRampControl(scen, gradient, u)
% Updates the control given a scenario, current control and gradient
switch globalDescentAlgorithm
    case 'basicGradientDescent'
        basicGD(scen, gradient, u);
    case 'backtrackingLineSearch'
        btLineSearch(scen, gradient, u);
    otherwise
        warning('Unknown descent algorithm');
end
end

function stop = stopIterating(scen, u, nextU, iteration)
    stop = (nextU - u < globalConvergenceThreshold) | (iteration > globalMaxIterations);
end