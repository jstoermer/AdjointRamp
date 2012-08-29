function u = adjoint_loop(scen,u0)
u = u0;
iter = 10;
counter = 0;
while counter < iter;
    counter = counter + 1;
    scen.u = u;
    scen = forward_sim(scen);
    adj = adjoint_sln(scen,scen.states);
    l = {scen.states.ramp_queues}; % l in cell array form
    % gradient step! u = gradientDescent(adj,l,u, scen?)
end
end

    