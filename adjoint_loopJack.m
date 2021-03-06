function u = adjoint_loopJack(scen,u0)
scen.R = 10; % HACK
scen.alpha = 0.5; % HACK

u = u0;
max_iter = 20;
scen.iter = 0;
vals = [];

while scen.iter < max_iter;
    scen.iter = scen.iter + 1;
    scen.u = u;
    scen = forward_sim(scen);
    lambda = adjoint_sln(scen,scen.states);
    u = updateControl(lambda, scen);
end
disp('\rho final');
reshape([scen.states.densities], scen.N+1, scen.T+1)'
rho = [scen.states.densities];
plt(1:length(vals),vals);
vals
l = {scen.states.ramp_queues};
l = cell2mat(l(1:end-1)');
disp('l final');
l
disp('u final');
u
disp('Final cost');
cost = [sum(rho) sum(sum(l))]
sum(cost)
end
    