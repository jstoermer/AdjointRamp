function u = adjoint_loop(scen,u0)
u = u0;
iter = 10;
counter = 0;
us = [];
while counter < iter;
    scen.iter = counter + 1;
    counter = counter + 1;
    scen.u = u;
    scen = forward_sim(scen);
    lambda = adjoint_sln(scen,scen.states);
    u = updateControl(lambda, scen);
end
end
