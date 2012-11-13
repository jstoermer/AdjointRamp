!git checkout master;
clear all;
net = 'samitha1onramp'
fn = ['networks/' net '.json'];
plotForwardSim(fn);
!git checkout dhdx;
clear all;
net = 'simple'
fn = ['networks/' net '.json'];
loadParameters;
scen = loadScenario(fn);
T = scen.T; N = scen.N;
u = ones(T,N).*.2;
plotForwardSim(scen,u);