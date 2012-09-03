clear all; clc; close all;
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

%D0_vec = [1.0,1.0,1.0,1.0,0,0,0,0,0];
D0_vec = [0.9,0.9,0.9,0.9,0,0,0,0,0];
D = [0,0;0.2,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0];
%D = [0,0;0.1,0;0.1,0;0,0;0,0;0,0;0,0;0,0;0,0];
%D = [0,0;1.5,0;0.5,0;0,0;0,0;0,0;0,0;0,0;0,0];
%D = [0,0;1,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0];
%D = [0,0;0.5,0;0.5,0;0,0;0,0;0,0;0,0;0,0;0,0];

u = ones(9,2);
u(3,1) = 0.1;

beta = zeros(9,2);


scen = scenario(p0_vec,l0_vec,D0_vec, D, cells, beta, dt, dx);
scen.u = u;
u
scen = forward_sim(scen);
l = {scen.states.ramp_queues};    
l = cell2mat(l(2:end)')

scen.states.densities
rhovec = sum([scen.states.densities]);
lvec = sum([scen.states.ramp_queues]);
vals = [rhovec lvec]
sum(vals)
% plot_states(scen.states);
% s = adjoint_sln(scen, scen.states)

adjoint_loopSamitha(scen,u);