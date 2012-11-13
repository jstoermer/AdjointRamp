!git checkout master;
clear all;
net = 'samitha1onramp'
fn = ['networks/' net '.json'];
plotBeforeAndAfter(fn);
!git checkout dhdxexp;
clear all;
net = 'samitha1onramp'
fn = ['networks/' net '.json'];
loadParameters;
scen = loadScenario(fn);
T = scen.T; N = scen.N;
u = ones(T,N).*.1;
plotBeforeAndAfter(scen,u);