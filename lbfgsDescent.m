function out = lbfgsDescent(uvec, obj, grad)
global parameters;
lb = zeros(size(uvec));
ub = ones(size(uvec)).*20;

out = lbfgsb(uvec,lb,ub,obj, grad,...
  [],'genericcallback','maxiter',parameters.globalMaxIterations,'m',4,'factr',1e-8,...
  'pgtol',parameters.globalConvergenceThreshold);
end