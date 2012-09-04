function [u_updated] = gradDecent(lambda, scen)
% Given the current control u and the parameters required for gradient
% decent, computes the new updated value of u 

t = findDecentStepSize(scen);

% fixed vars
lambda5 = extractLambda5(lambda, scen)';

% current iteration vars
u = scen.u;
l_cell = {scen.states.ramp_queues};
l = cell2mat(l_cell(1:end-1)');

% current iteration derivatives
partialJ_u = computePartialJ_u(scen.R,u,l);
diagOfPartialH5_u = computePartialH5_u(u,l);
gradJ_u = partialJ_u + lambda5.*diagOfPartialH5_u;

% u_updated = u - t*gradJ_u
u_updated = update_u(u, t, gradJ_u, scen);

end
