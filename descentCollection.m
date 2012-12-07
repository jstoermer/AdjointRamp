function out = descentCollection


out.gdBackTracking = standardGradientDescentSpecifyLS(@backtrackingLineSearch);
out.gdBasic = standardGradientDescentSpecifyLS(@basicLineSearch);
out.gdBackTrackingPos = standardGradientDescentSpecifyLS(boundedLineSearch(0, inf, @backtrackingLineSearch));
out.gdBasicPos = standardGradientDescentSpecifyLS(boundedLineSearch(0, inf, @basicLineSearch));

out.bfgs = @unboundedBFGS;
out.bfgsPos = @strictlyPositiveLBFGS;

end

function out = boundedLineSearch(bottom, top, ls)
out = @ (u, gradient, cost, iteration) min(top, max(bottom,ls(u, gradient, cost, iteration)));
end


function out = standardGradientDescentSpecifyLS(lineSearch)
global parameters;
  function out = helper(u0, objective, gradient)
    out = gradientDescent(u0, objective, gradient, parameters.globalMaxIterations,lineSearch, @stopIterating);
  end
out = @helper;
end


function out = unboundedBFGS(u, obj, grad)
out = lbfgsDescent(u, obj, grad, -inf.*ones(size(u)), inf.*ones(size(u)));
end

function out = strictlyPositiveLBFGS(u0, objective, gradient)

out = lbfgsDescent(u0, objective, gradient, zeros(size(u0)), ones(size(u0)).*inf);
end

function out = lbfgsDescent(uvec, obj, grad, lb, ub)
global parameters;
clear bfgsStore;
global bfgsStore;
bfgsStore.evaluateCost = obj;
bfgsStore.evaluateGradient = grad;

out = lbfgsb(uvec,lb,ub,'bfgsCostWrapper', 'bfgsGradientWrapper',...
  [],'genericcallback','maxiter',parameters.globalMaxIterations,'m',4,'factr',1e-8,...
  'pgtol',parameters.globalConvergenceThreshold);
clear bfgsStore;
end


function out = basicLineSearch(u, gradient, ~, iteration)
global parameters
if isfield(parameters, 'alpha')
  alpha = parameters.alpha;
else
  alpha = 0.1;
end
stepSize=parameters.alpha/sqrt(iteration);
out = u  - stepSize.*gradient;
end


function out = backtrackingLineSearch(x, gradient, cost, ~)
global parameters
if isfield(parameters, 'bt')
  alpha = parameters.bt.alpha;
  beta =  parameters.bt.beta;
else
  alpha = 0.5;
  beta = 0.9;
end

t = 1;
dx = -gradient;
cx = cost(x);
gradProduct = gradient'*dx;


counter = 0;
MAX_ITER = 100;
while cost(x + t.*dx) > cx + alpha.*t.*gradProduct
  t = beta*t;
  counter= counter + 1;
  if counter > MAX_ITER
    break;
  end
end
out = x + t.*dx;
end


function stop = stopIterating(u, nextU, iteration)
global parameters;
stop = (norm(nextU - u) < parameters.globalConvergenceThreshold) | (iteration > parameters.globalMaxIterations);
end