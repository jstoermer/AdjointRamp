function out = basicGD(scen, gradient, u, iter)
% Given the current control $u$ and the update parameters, output the 
% updated value of $u$
uvec = u; uvec = uvec(:);
out = reshape(max(uvec - findDescentStepSize(iter)*gradient',0), scen.N, scen.T)';
end