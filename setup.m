global parameters

parameters.R = 0.10;
%% gradient methods
% 1. gradient descent
% 2. l-bfgs

colls = descentCollection;
parameters.globalDescentAlgorithm = colls.gdBasicPos;
%parameters.globalDescentAlgorithm = colls.gdBackTrackingPos;
parameters.alpha = 0.10;
colls = descentCollection;
parameters.lineSearch = colls.gdBackTracking;
parameters.globalConvergenceThreshold = 1.00e-8;
parameters.globalMaxIterations = 100;

% how much to scale the control when not specified w/r/t the max flux per
% ramp
parameters.defaultUScale = 0.95;

%% backtracking line search specifics

parameters.bt.alpha = 0.50;
parameters.bt.beta = 0.90;

loadScenario = @io.loadScenario;

addpath(pwd);
