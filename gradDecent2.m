function [u_updated] = gradDecent2(lambda, scen)
% Given the current control u and the parameters required for gradient
% decent, computes the new updated value of u 

t = scen.alpha/sqrt(scen.iter);


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

% current iteration cost
curr_cost = cost_function(scen);

lambda5 = extractLambda5(lambda, scen)';
gradJ_u = partialJ_u + lambda5.*diagOfPartialH5_u;

t = findDecentStepSize(scen);

u_vect = reshape(u',1,scen.T*(scen.N-1));
u_updated = u_vect - t*gradJ_u;

u_updated = reshape(u_updated', scen.T, scen.N-1);
u_updated = max(u_updated,0);

end
