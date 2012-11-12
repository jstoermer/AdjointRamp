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



function out = gradientRampControl(scen, states, u)
% Finds the gradient for a given scenario, control and resulting output state    
global parameters;

% get params
l = states.queue;
R = parameters.R;

% Compute the gradient
out = dj_du(R,u,l)' + adjoint_sln(scen,states, u)'*dh_du(u,l);

end

function out = nextRampControl(scen, gradient, u)
% Updates the control given a scenario, current control and gradient
global parameters;
switch parameters.globalDescentAlgorithm
  case 'basicGradientDescent'
    out = basicGD(scen, gradient, u);
  case 'backtrackingLineSearch'
    out = btLineSearch(scen, gradient, u);
  case 'lbfgs'
    out = adjointBFGS(scen, gradient, u);
  otherwise
    error('Unknown descent algorithm');
end
end

function stop = stopIterating(scen, u, nextU, iteration)
    stop = (nextU - u < globalConvergenceThreshold) | (iteration > globalMaxIterations);
end