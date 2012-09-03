function [ u ] = backtrackingLineSearch(lambda, scen, iter)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% search params
alpha = 0.4;
beta = 0.5;
t = 1/sqrt(iter);

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
partialJ_u
lambda5
diagOfPartialH5_u
secondTerm = lambda5.*diagOfPartialH5_u
gradJ_u
% current iteration cost
curr_cost = cost_function(scen);

terminate = false;

count = 0;
maxCount = 1;
while (~terminate)
    count = count + 1;
    % update control
    u_vect = reshape(u,1,scen.T*(scen.N-1));
    u_updated_vect = u_vect - t*gradJ_u;
    % Check whether doing the max here makes sense with backtracking line
    % search
    u_updated_vect = max(u_updated_vect,0);
    l_vect = reshape(l,1,scen.T*(scen.N-1));
    u_updated_vect = min(u_updated_vect,l_vect);
    u_updated = reshape(u_updated_vect', scen.T, scen.N-1);
    
    % update forward sim
    scen_new = scen;
    scen_new.u = u_updated;
    scen_new = forward_sim(scen_new);
    u
    u_updated
    queue = reshape([scen_new.states.ramp_queues],scen.N-1,scen.T+1)'
    %l_new = cell2mat({scen.states.ramp_queues}');
    %partialJ_u_new = computePartialJ_u(scen_new.R,u,l_new);
    %diagOfPartialH5_u_new = computePartialH5_u(u,l_new);
    %gradJ_u_new = partialJ_u_new + lambda5.*diagOfPartialH5_u_new;

    % new cost 
    new_cost = cost_function(scen_new);
    
    % termination check
    if ((new_cost < curr_cost + alpha*t*gradJ_u*(u_updated_vect - u_vect)') || (count >= maxCount))
        terminate = true;
    else
        % update vars
        t = beta*t;
        curr_cost = new_cost;
        scen = scen_new;
        %gradJ_u = gradJ_u_new;
        
    end
    u = u_updated;
end

