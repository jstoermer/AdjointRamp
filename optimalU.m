function [u, outputState] = optimalU(varargin)
% Computes the optimal ramp metering control for a given scenario
% Inputs
% varargin(1) - JSON description of a scenario or the scenario structure
% varargin(2) - (optional) Initial control
% Outputs
% u - Optimal control 
% outputState - State evolution resulting from the optimal control

[scen u] = scenUVarArgIn(varargin, .8);

iteration = 0;
while true
    iteration = iteration + 1;
    outputState = forwardSimulation(scen, u);
    totalTravelTime(scen, outputState, u);
    gradient = gradientRampControl(scen, outputState, u);
    full(gradient);
    nextU = nextRampControl(scen, gradient, u, iteration);
    nextU
    if stopIterating(scen, u, nextU, iteration)
        u = nextU;
        return;
    end
    u = nextU;
end

end



function out = gradientRampControl(scen, states, u)
% Finds the gradient for a given scenario, control and resulting output state    
global parameters;

% get params
l = states.queue;
R = parameters.R;

djdu = dj_du(scen, states, u)';
lambda = adjoint_sln(scen,states, u)';
dhdu = dh_du(u,l);


% Compute the gradient
out = djdu + lambda*dhdu;

end

function out = nextRampControl(scen, gradient, u, iter)
% Updates the control given a scenario, current control and gradient
global parameters;
switch parameters.globalDescentAlgorithm
  case 'basicGradientDescent'
    out = basicGD(scen, gradient, u, iter);
  case 'backtrackingLineSearch'
    out = btLineSearch(scen, gradient, u);
  case 'lbfgs'
    out = adjointBFGS(scen, gradient, u);
  otherwise
    error('Unknown descent algorithm');
end
end

function stop = stopIterating(scen, u, nextU, iteration)
global parameters;
    stop = (norm(nextU - u) < parameters.globalConvergenceThreshold) | (iteration > parameters.globalMaxIterations);
end