function gradJ_u =  gradientBFGS(u)
global scen;
scen.u = reshapeUBFGS(u,scen);
scen = forward_sim(scen);
lambda = adjoint_sln(scen,scen.states);
lambda5 = extractLambda5(lambda, scen)';

% current iteration vars
u = scen.u;
l_cell = {scen.states.ramp_queues};
l = cell2mat(l_cell(1:end-1)');
partialJ_u = computePartialJ_u(scen.R,u,l);
diagOfPartialH5_u = computePartialH5_u(u,l);
gradJ_u = partialJ_u + lambda5.*diagOfPartialH5_u;
end