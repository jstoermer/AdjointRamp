function u = adjoint_loopSamitha(scen,u0)
scen.R = 1; % HACK
scen.alpha = .001; % HACK
u = u0;
iter = 25;
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
    l = cell2mat(l(2:end)');
    u = updateControl(u, l, lambda, scen);
end
u
plt(1:length(vals),vals);

end
