clear all; clc; % close all;
dt = 1; dx = 1; N = 3; T = 20;
l_vec = [1,1,1];
v_vec = [1,1,1];
w_vec = [1,1,1];
fm_vec = [1,1,.3];

for i = 1:N
    cells(i) = highway_cell(v_vec(i), w_vec(i), fm_vec(i), l_vec(i));
end

p0_vec = zeros(T,N);
l0_vec = zeros(T,N);
D0_vec = zeros(1,T);
D = zeros(T,N-1);

D0_vec(1:4) = [.5,2.0,1.0,.2];
D(1:3,1) = [.3,.3,.3]';

u = ones(T, N-1).*20.0;

beta = zeros(T,N-1);


scen = scenario(p0_vec,l0_vec,D0_vec, D, cells, beta, dt, dx);
scen.R = .1; % HACK
scen.alpha = .001; % HACK
scen.u = u;
scen = forward_sim(scen);
% plot_states(scen.states);
disp(cost_function(scen));

% adjoint_loop(scen,u);