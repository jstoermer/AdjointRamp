clear all; clc; close all;
dt = 1; dx = 1; N = 3;
l_vec = [1,1,1];
v_vec = [1,1,1];
w_vec = [1,1,1];
fm_vec = [1,1,.5];

for i = 1:N
    cells(i) = highway_cell(v_vec(i), w_vec(i), fm_vec(i), l_vec(i));
end

p0_vec = [0,0,0];
l0_vec = [0,0,0];

D0_vec = [10,0.5,0.8,0,0,0,0,0,0];

D = [.3,.3;
    .3,.1;
    .3,.3;
    .0,.0;
    0,0;
    0,0;
    0,0;
    0,0;
    0,0;];

u = [.3,.3;
    .1,.3;
    .2,.3;
    .3,.3;
    .3,.3;
    .3,.3;
    .3,.3;
    .3,.3;
    .3,.3;];

beta = [0,.2;
    .2,.2;
    0,.2;
    0,.2;
    0,.8;
    .9,0;
    0,0;
    0,0;
    0,0;];


scen = scenario(p0_vec,l0_vec,D0_vec, D, cells, beta, dt, dx);
scen.u = u;
% scen = forward_sim(scen);
% plot_states(scen.states);
% s = adjoint_sln(scen, scen.states)

u = adjoint_loop(scen,u);