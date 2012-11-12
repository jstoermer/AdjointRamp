function [ u ] = backtrackingLineSearch(scen, gradJ_u, u)

t = findDecentStepSize(scen);

% current iteration cost
curr_cost = cost_function(scen);

terminate = false;
count = 0;
while (~terminate)
    count = count + 1;

    % update control
    % u_updated = u - t*gradJ_u
    [u, u_vect, u_updated_vect] = update_u(t, scen, gradJ_u, u);
    
    % forward sim
    scen.u = u;
    scen = forward_sim(scen);

    % new cost 
    new_cost = cost_function(scen);
    
    % termination check
    if ((new_cost < curr_cost + alpha*t*gradJ_u*(u_updated_vect - u_vect)') || (count >= parameters.btLineSearch.maxIters ))
        terminate = true;
    else
        % update vars
        t = beta*t;
        curr_cost = new_cost;
    end
end

