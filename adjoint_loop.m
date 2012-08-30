function u = adjoint_loop(scen,u0)
scen.R = 1; % HACK
scen.alpha = .1; % HACK
u = u0;
iter = 10;
counter = 0;
while counter < iter;
    counter = counter + 1;
    scen.u = u;
    scen = forward_sim(scen);
    lambda = adjoint_sln(scen,scen.states);
    l = {scen.states.ramp_queues};
    l = cell2mat(l(2:end)');
    size(l);
    u = updateControl(u, l, lambda, scen);
end
end
