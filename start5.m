%% setup
close all; clear scen; clc; % close all;

%% constants
dt = 1; dx = 1; N = 3; T = 100;
l_vec = [1,1,1];
v_vec = [1,1,1];
w_vec = [1,1,1].*1;
fm_vec = [1,1,1];

R = 0;
alpha = .01;

p0_vec = zeros(T,N);
l0_vec = zeros(T,N);
D0_vec = zeros(1,T);
D = zeros(T,N-1);

D0_vec(1) = [20];
D(10,2) = 5;

u = ones(T, N-1).*20.0;


beta = zeros(T,N-1);

%% create cells


for i = 1:N
    cells(i) = highway_cell(v_vec(i), w_vec(i), fm_vec(i), l_vec(i));
end



%% scenario 1

scen = scenario(p0_vec,l0_vec,D0_vec, D, cells, beta, dt, dx);
scen.R = R;
scen.alpha = alpha;
scen.u = u;
scen = forward_sim(scen);
[a,b,c,d] = cost_function(scen);
[a;b;c;d;]

c1 = cell2mat({scen.states.densities}')';
l1 = cell2mat({scen.states.ramp_queues}')';


%% scenario 2

u = zeros(T, N-1).*20.0;
u(28:end,:) = 20;
clear scen;

scen = scenario(p0_vec,l0_vec,D0_vec, D, cells, beta, dt, dx);
scen.R = R;
scen.alpha = alpha;
scen.u = u;
scen = forward_sim(scen);
[a,b,c,d] = cost_function(scen);
[a;b;c;d;]

c2 = cell2mat({scen.states.densities}')';
l2 = cell2mat({scen.states.ramp_queues}')';

%% plotting


plt(1:length(c1), [c1;c2]);
plt(1:length(l1), [l1;l2]);
