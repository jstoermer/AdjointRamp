function [stepSize] = findDecentStepSize(params)
% Compute the optimal step size given the parameters
stepSize=params.alpha*ones(1,params.T*(params.N-1))/params.iter;

end

