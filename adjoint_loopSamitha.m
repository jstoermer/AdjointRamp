function u = adjoint_loopSamitha(scen,u0)
scen.R = 10; % HACK
scen.alpha = 0.05; % HACK

u = u0;
max_iter = 25;
scen.iter = 0;

while scen.iter < max_iter;
    scen.iter = scen.iter + 1;
    scen.u = u;
    scen = forward_sim(scen);
    lambda = adjoint_sln(scen,scen.states);
    u = updateControl(lambda, scen)
end
end
    