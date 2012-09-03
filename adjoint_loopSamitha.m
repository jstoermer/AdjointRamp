function u = adjoint_loopSamitha(scen,u0)
scen.R = 0; % HACK
scen.alpha = 0.01; % HACK
u = u0;
iter = 10;
counter = 0;
vals = [];
u0
while counter < iter;
    scen.iter = counter + 1;
    counter = counter + 1;
    scen.u = u;
    scen = forward_sim(scen);
    [v1,v2,v3,v4] = cost_function(scen);
    vals = [vals, [v1,v2,v3,v4]'];
    lambda = adjoint_sln(scen,scen.states);
    l = {scen.states.ramp_queues};
    l = cell2mat(l(1:end-1)');
    u = updateControl(lambda, scen, counter);
end
scen.states.densities
rho = [scen.states.densities];
plt(1:length(vals),vals);
cost = [sum(rho) sum(sum(l))]
sum(cost)
end
    