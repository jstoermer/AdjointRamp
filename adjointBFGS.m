function out = adjointBFGS(scen, u)
clear bfgsStore;
global parameters;
global bfgsStore;
bfgsStore.scen = scen;

uvec = stacker(u);
lb = zeros(size(uvec));
ub = ones(size(uvec)).*20;

final_u = lbfgsb(uvec,lb,ub,'costFunctionBFGS','gradientBFGS',...
           [],'genericcallback','maxiter',parameters.globalMaxIterations,'m',4,'factr',1e-8,...
           'pgtol',parameters.globalConvergenceThreshold);
out = unstack(final_u, scen);
end