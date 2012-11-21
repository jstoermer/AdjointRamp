%% setup
close all; clear scen; clc; % close all;

%% constants
dt = 1; dx = 1; N = 12; T = N*6;
l_vec = ones(1,N);
v_vec = ones(1,N);
w_vec = ones(1,N);
fm_vec = ones(1,N);


p = 0.8*ones(1,N);

p0_vec = zeros(1,N);
l0_vec = zeros(1,N);
D = zeros(T,N);

D(1) = N*1;
D(N-1,N-1) = N*2;

u = ones(T, N-1) * .2;


beta = zeros(T,N);
beta(:,N-2) = .1;

%% half offramp and onramp

half = ceil(N/2);
D(half,half) = N*2;
beta(:,half - 1) = .1;

rmax = ones(1,N);

scen.dt = dt;
scen.l0 = l0_vec;
scen.L = l_vec;
scen.v = v_vec;
scen.w = w_vec;
scen.fm = fm_vec;
scen.p = p;
scen.p0 = p0_vec;
scen.D = D;
scen.beta = beta;
scen.rmax = rmax;

savejson('',scen, 'networks/2on2off.json')