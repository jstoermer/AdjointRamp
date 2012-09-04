function x = adjointBFGS(sc, u0)
global scen;
scen = sc;

x0 = unshapeUBFGS(u0);
lb = zeros(size(x0));
ub = ones(size(x0)).*10000;

x = lbfgsb(x0,lb,ub,'costFunctionBFGS','gradientBFGS',...
           [],'genericcallback','maxiter',80,'m',4,'factr',1e-12,...
           'pgtol',1e-5);


end