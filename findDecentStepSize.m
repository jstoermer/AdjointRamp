function [stepSize] = findDecentStepSize(params)
% Compute the optimal step size given the parameters
stepSize=params.alpha/params.iter;
end

