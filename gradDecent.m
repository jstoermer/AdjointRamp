function [u_updated] = gradDecent(u, partialJ_u, diagOfPartialH5_u, lambda, scen)
% Given the current control u and the parameters required for gradient
% decent, computes the new updated value of u 

lambda5 = extractLambda5(lambda, scen)';
gradJ_u = partialJ_u + lambda5.*diagOfPartialH5_u;

t = findDecentStepSize(scen);

u_vect = reshape(u',1,scen.T*(scen.N-1));
u_updated = u_vect - t*gradJ_u;

u_updated = reshape(u_updated', scen.T, scen.N-1);
u_updated = max(u_updated,0);

end
