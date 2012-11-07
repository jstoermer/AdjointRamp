%% setup
close all; clear scen; clc; % close all;

%% constants
dt = 1; dx = 1; N = 12; T = N*6;
l_vec = ones(1,N);
v_vec = ones(1,N);
w_vec = ones(1,N);
fm_vec = ones(1,N);

R = 1;

p0_vec = zeros(T,N);
l0_vec = zeros(T,N);
D0_vec = zeros(1,T);
D = zeros(T,N-1);

D0_vec(1) = N*1;
D(N-1,N-1) = N*2;

u = ones(T, N-1) * .2;


beta = zeros(T,N-1);
beta(:,N-2) = .1;

%% half offramp and onramp

half = ceil(N/2);
D(half,half) = N*2;
beta(:,half - 1) = .1;




%% create cells


for i = 1:N
    cells(i) = highway_cell(v_vec(i), w_vec(i), fm_vec(i), l_vec(i));
end



%% scenario 1

scen = scenario(p0_vec,l0_vec,D0_vec, D, cells, beta, dt, dx);
scen.R = R;


%% special u

% u(1:N*3,:) = .7;

% scen.u = u;
tic;
u_grad = adjoint_loopSamitha(scen, u);
%[scen_grad scen_bfgs] = compareControls(scen, u_grad, u_bfgs);
%l_gradc = {scen_grad.states.ramp_queues};
%l_grad = cell2mat(l_gradc(1:end-1)')

display('grad decent time');
t1 = toc

% u_bfgs = adjointBFGS(scen,u)
% display('bfgs time');
% t2 = toc - t1
% display('bfgs l');
%l_bfgsc = {scen_bfgs.states.ramp_queues};
%l_bfgs = cell2mat(l_bfgsc(1:end-1)')
% 
% t2
% compareControlPlot(scen, u);
%scen = mpcRamp(scen, u, 1,1);

% scen = forward_sim(scen);
% plot_states(scen.states);
% disp(cost_function(scen));
