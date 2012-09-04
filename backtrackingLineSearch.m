function [ u ] = backtrackingLineSearch(lambda, scen, iter)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% search params
alpha = 0.01;
beta = 0.5;
t = 1;

% fixed vars
lambda5 = extractLambda5(lambda, scen)';

% current iteration vars
u = scen.u;
l = {scen.states.ramp_queues};
l = cell2mat(l(1:end-1)');

% current iteration derivatives
partialJ_u = computePartialJ_u(scen.R,u,l);
diagOfPartialH5_u = computePartialH5_u(u,l);
gradJ_u = partialJ_u + lambda5.*diagOfPartialH5_u;

% current iteration cost
curr_cost = cost_function(scen);

terminate = false;

count = 0;
maxCount = 1;
while (~terminate)
    count = count + 1;

    % update control
    % u_updated = u - t*gradJ_u
    [u, u_vect, u_updated_vect] = update_u(u, t, gradJ_u, scen);
    
    % forward sim
    scen.u = u;
    scen = forward_sim(scen);

    % new cost 
    new_cost = cost_function(scen);
    
    % termination check
    if ((new_cost < curr_cost + alpha*t*gradJ_u*(u_updated_vect - u_vect)') || (count >= maxCount))
        terminate = true;
    else
        % update vars
        t = beta*t;
        curr_cost = new_cost;
    end
end

