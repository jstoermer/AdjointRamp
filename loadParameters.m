global parameters

parameters.R = 10;
%% gradient methods
% 1. gradient descent
% 2. l-bfgs

parameters.globalDescentAlgorithm = 'basicGradientDescent';
% parameters.globalDescentAlgorithm = 'lbfgs';
parameters.alpha = .05;
parameters.globalConvergenceThreshold = .0001;
parameters.globalMaxIterations = 20;

% how much to scale the control when not specified w/r/t the max flux per
% ramp
parameters.defaultUScale = .6;