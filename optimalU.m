function [u, outputState] = optimalU(varargin)
% Computes the optimal ramp metering control for a given scenario
% Inputs
% varargin(1) - JSON description of a scenario or the scenario structure
% varargin(2) - (optional) Initial control
% Outputs
% u - Optimal control 
% outputState - State evolution resulting from the optimal control

global parameters;
[scen u] = scenUVarArgIn(varargin);
if strcmp(parameters.globalDescentAlgorithm, 'lbfgs')
  u = adjointBFGS(scen, u);
  outputState = forwardSimulation(scen, u);
  return;
end

iteration = 0;
while true
    iteration = iteration + 1;
    outputState = forwardSimulation(scen, u);
    totalTravelTime(scen, outputState, u)
    gradient = gradientRampControl(scen, outputState, u);
    nextU = nextRampControl(scen, gradient, u, iteration);
    if stopIterating(scen, u, nextU, iteration)
        u = nextU;
        return;
    end
    u = nextU;
end

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