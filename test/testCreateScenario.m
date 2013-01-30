clc; close all;
N = 10;
T = 30;
global parameters
parameters.R = 0;
scen = createScenario(N,T);

no_u = noControlU(scen);
u_1 = no_u.*.8;
% 
% fs1 = forwardSimulation(scen ,no_u);
% disp(totalTravelTime(scen, fs1, no_u))
% pause
% u_star = rampOptimalU(scen, u_1);
% fs2 = forwardSimulation(scen, u_star);
% disp(totalTravelTime(scen, fs2, u_star))
% plotting.plotForwardSim(scen, no_u);
% plotting.plotForwardSim(scen, u_star);

fs1 = forwardSimulation(scen, no_u);
disp(sum(sum(fs1.density)) + sum(sum(fs1.queue)));
pause
fs2 = forwardSimulation(scen , rampOptimalU(scen, u_1));


plotting.spaceTimePlot(fs2.density - fs1.density, true);
plotting.spaceTimePlot(fs2.queue - fs1.queue, true);
disp(sum(sum(fs2.density)) + sum(sum(fs2.queue)));


% plotting.plotNoControlVsOptimal(scen, u_1);
