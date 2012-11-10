function [u, outputState] = optimalU(varargin)
% Computes the optimal ramp metering control for a given scenario
% Inputs
% varargin(1) - JSON description of a scenario or the scenario structure
% varargin(2) - (optional) Initial control
% Outputs
% u - Optimal control 
% outputState - State evolution resulting from the optimal control

scen = loadScenario(varargin{1});
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



function gradientJ_u = gradientRampControl(scen, outputState, u)
% Finds the gradient for a given scenario, control and resulting output state    

    % Find the adjoint parameters
    lambda = adjoint_sln(scen,outputState);
    lambda5 = extractLambda5(lambda, scen)';
    
    % Get l in flat format
    l_cell = {outputState.ramp_queues};
    l = cell2mat(l_cell(1:end-1)');

    % Compute the gradient    
    partialJ_u = computePartialJ_u(scen.R,u,l);
    diagOfPartialH5_u = computePartialH5_u(u,l);
    gradientJ_u = partialJ_u + lambda5.*diagOfPartialH5_u;
    
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