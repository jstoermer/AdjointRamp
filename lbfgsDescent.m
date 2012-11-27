function out = lbfgsDescent(uvec, obj, grad, lb, ub)
global parameters;
clear bfgsStore;
global bfgsStore;
bfgsStore.evaluateCost = obj;
bfgsStore.evaluateGradient = grad;

out = lbfgsb(uvec,lb,ub,'costBFGS', 'gradientBFGS',...
  [],'genericcallback','maxiter',parameters.globalMaxIterations,'m',4,'factr',1e-8,...
  'pgtol',parameters.globalConvergenceThreshold);
end