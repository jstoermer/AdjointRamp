function out = basicGD(scen, gradient, u, iter)
% Given the current control $u$ and the update parameters, output the 
% updated value of $u$
out = reshape(max(u(:) - findDescentStepSize(iter)*gradient',0), scen.T, scen.N);
end