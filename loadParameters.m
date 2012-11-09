global parameters

%% Regularization parameter for avoiding u > l
parameters.R = .1;

%% gradient methods
% 1. gradient descent
% 2. l-bfgs

parameters.gradient_method = 1;


%% Decent Algorithm
% parameters.descentAlgorithm
%   basicGradientDescent - use basic gradient descent algorithm
%   backtrackingLineSearch - use backtracking line search algorithm

% current value
parameters.descentAlgorithm = 'basicGradientDescent';


%% Backtracking line search parameters

parameters.btlinesearch.alpha = 0.2;
parameters.btlinesearch.beta = 0.5;

