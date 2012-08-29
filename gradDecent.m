function [u_updated] = gradDecent(u, partialJ_u, diagOfPartialH5_u, lambda, params)
% Given the current control u and the parameters required for gradient
% decent, computes the new updated value of u 

lambda5 = extractConstraint5(lambda, params);
gradJ_u = partialJ_u + lambda5(1:params.T*(params.N-1)).*diagOfPartialH5_u;
alpha = findDecentStepSize(params);
u_vect = reshape(u',1,params.T*(params.N-1));
u_updated = u_vect - alpha.*gradJ_u;
u_updated = reshape(u_updated', params.T, params.N-1);
end
