function u = adjoint_loop(scen,u0)
u = u0;
iter = 10;
counter = 0;
while counter < iter;
    counter = counter + 1;
    scen.u = u;
    scen = forward_sim(scen);
    lambda = adjoint_sln(scen,scen.states);
    u = updateControl(scen, lambda);
    l = {scen.states.ramp_queues};
    % N = scen.N
    % T = scen.T
    % lambda_5k = lambda_5(scen,lambda,k)
    
end
end

    