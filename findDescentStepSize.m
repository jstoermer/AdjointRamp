function [stepSize] = findDescentStepSize(iter)
% Compute the optimal step size given the parameters
global parameters;
stepSize=parameters.alpha/sqrt(iter);
end

