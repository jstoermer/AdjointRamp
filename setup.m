global parameters

parameters.R = 1e-5;
%% gradient methods
% 1. gradient descent
% 2. l-bfgs

colls = descentCollection;
% parameters.globalDescentAlgorithm = colls.gdBasicPos;
% parameters.globalDescentAlgorithm = colls.gdBackTrackingPos;
parameters.globalDescentAlgorithm = colls.fMinCon;

parameters.alpha = 0.50;
colls = descentCollection;
parameters.lineSearch = colls.gdBackTracking;
parameters.globalConvergenceThreshold = 1e-8;
parameters.globalMaxIterations = 100;

% how much to scale the control when not specified w/r/t the max flux per
% ramp
parameters.defaultUScale = 0.5;

%% backtracking line search specifics

parameters.bt.alpha = 0.50;
parameters.bt.beta = 0.90;

loadScenario = @io.loadScenario;

addpath(pwd);
