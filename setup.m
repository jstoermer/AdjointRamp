global parameters

parameters.R = 10;
%% gradient methods
% 1. gradient descent
% 2. l-bfgs

colls = descentCollection;
parameters.globalDescentAlgorithm = colls.gdBasicPos;
%parameters.globalDescentAlgorithm = colls.gdBackTrackingPos;
parameters.alpha = 0.2;
colls = descentCollection;
parameters.lineSearch = colls.gdBackTracking;
parameters.globalConvergenceThreshold = .00000001;
parameters.globalMaxIterations = 10;

% how much to scale the control when not specified w/r/t the max flux per
% ramp
parameters.defaultUScale = 0.95;

%% backtracking line search specifics

parameters.bt.alpha = .5;
parameters.bt.beta = .9;

loadScenario = @io.loadScenario;

addpath(pwd);
