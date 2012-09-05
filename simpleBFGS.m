clear scen; clc; close all;
dt = 1; dx = 1; N = 3;
l_vec = [1,1,1];
v_vec = [1,1,1];
w_vec = [1,1,1];
fm_vec = [0.9,1,1];

for i = 1:N
    cells(i) = highway_cell(v_vec(i), w_vec(i), fm_vec(i), l_vec(i));
end

p0_vec = [0,0,0];
l0_vec = [0,0,0];

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

u = ones(9,2).*0;
% u(3,1) = 0.10;
% u(4,1) = 0.10;

beta = zeros(9,2);

scen = scenario(p0_vec,l0_vec,D0_vec, D, cells, beta, dt, dx);
scen.R = 10;
s = adjointBFGS(scen, u);
scen.alpha = .1;
s = adjoint_loop(scen, u);
% compareControlPlot(scen, u);
% scen = mpc(scen, u, 1, 2);
