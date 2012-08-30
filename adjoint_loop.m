function u = adjoint_loop(scen,u0)
u = u0;
iter = 10;
counter = 0;
vals = [];
us = [];
while counter < iter;
    counter
    us = [us, u(:)];
    scen.iter = counter + 1;
    counter = counter + 1;
    scen.u = u;
    scen = forward_sim(scen);
    [v1,v2,v3,v4] = cost_function(scen);
    vals = [vals, [v1,v2,v3,v4]'];
    lambda = adjoint_sln(scen,scen.states);
    l = {scen.states.ramp_queues};
    l = cell2mat(l(2:end)');
    u = updateControl(u, l, lambda, scen);
end
plt(1:length(vals),vals);
end
