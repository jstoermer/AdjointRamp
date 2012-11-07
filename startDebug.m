clear scen; clc; close all; clear all;
dt = 1; dx = 1; N = 3;
l_vec = [1,1,1];
v_vec = [1,1,1];
w_vec = [1,1,1];
%fm_vec = [1,1.5,1.5];
fm_vec = [0.9,1,1];

for i = 1:N
    cells(i) = highway_cell(v_vec(i), w_vec(i), fm_vec(i), l_vec(i));
end

p0_vec = [0,0,0];
l0_vec = [0,0,0];

%D0_vec = [1,1,1,1,0,0,0,0,0];
D0_vec = [0.9,0.9,0.9,0.9,0,0,0,0,0];
D = [0,0;
    0.2,0;
    0,0;
    0,0;
    0,0;
    0,0;
    0,0;
    0,0;
    0,0];
%D = [0,0;0.1,0;0.1,0;0,0;0,0;0,0;0,0;0,0;0,0];
%D = [0,0;1.5,0;0.5,0;0,0;0,0;0,0;0,0;0,0;0,0];
%D = [0,0;1,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0];
%D = [0,0;0.5,0;0.5,0;0,0;0,0;0,0;0,0;0,0;0,0];

u = ones(9,2);
%u(3,1) = 0.10;
%u(4,1) = 0.10;

niters = 2;

beta = zeros(9,2);
us = linspace(0.0999,0.1001,niters);
for iter = 1:niters
    clear scen.states;
    clear scen;
    u(3,1) = us(iter);
    scen = scenario(p0_vec,l0_vec,D0_vec, D, cells, beta, dt, dx);
    scen.u = u;
    scen.R = 0;
    scen = forward_sim(scen);
    lambda = adjoint_sln(scen, scen.states);
    debug_rho(1,iter) = lambda(idx_lookup(3,'rho',1,scen.N));
    debug_r(1,iter) = lambda(idx_lookup(2,'r',1,scen.N));
    debug_cost(1,iter) = cost_function(scen);
    debug_dhdx(:,:,iter) = full(dh_dx(scen, scen.states));
%    l = cell2mat(l(1:end-1)')
%    scen.states.densities
%    rhovec = sum([scen.states.densities]);
%    lvec = sum([scen.states.ramp_queues]);
%    vals = [rhovec lvec]
%    sum(vals)
    % plot_states(scen.states);
end

x = [us; abs(full(debug_rho)); full(debug_r); debug_cost]'
plot(x(:,2:3))

%adjoint_loopSamitha(scen,u);