function final_u = adjointBFGS(sc, u0)
global scen;
scen = sc;

x0 = unshapeUBFGS(u0);
lb = zeros(size(x0));
ub = ones(size(x0)).*20;

final_u = lbfgsb(x0,lb,ub,'costFunctionBFGS','gradientBFGS',...
           [],'genericcallback','maxiter',10,'m',4,'factr',1e-8,...
           'pgtol',1e-2);
final_u = reshapeUBFGS(final_u, scen);
end