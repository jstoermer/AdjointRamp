function [u_updated] = gradDecent(u, partialJ_u, partialH5_u, lambda, params)
% Given the current control u and the parameters required for gradient
% decent, computes the new updated value of u 

lambda5 = extractLambda5(lambda, params);
gradJ_u = partialJ_u + lambda5'.*partialH5_u;
alpha = findDecentStepSize();
u_updated = u - alpha*gradJ_u;

end
