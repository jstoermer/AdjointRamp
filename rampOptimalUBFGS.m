function out = rampOptimalUBFGS(scen, u)
clear rampStore;
global parameters;
global rampStore;
rampStore.scen = scen;

uvec = stacker(u);
lb = zeros(size(uvec));
ub = ones(size(uvec)).*20;

final_u = lbfgsb(uvec,lb,ub,'rampCostFunctionFromControl','rampGradientFromControl',...
           [],'genericcallback','maxiter',parameters.globalMaxIterations,'m',4,'factr',1e-8,...
           'pgtol',parameters.globalConvergenceThreshold);
out = unstack(final_u, scen);
end