function out = basicLineSearch(u, gradient, cost, iteration)
global parameters
if isfield(parameters, 'alpha')
  alpha = parameters.alpha;
else
  alpha = 0.1;
end
stepSize=parameters.alpha/sqrt(iteration);
out = u  - stepSize.*gradient;
end
