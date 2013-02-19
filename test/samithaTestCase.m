function samithaTest

close all
global u12;

global parameters;
parameters.R =1000;
parameters.alpha = .1;
parameters.globalMaxIterations = 400;
u12 = [];
scen = io.loadScenario('../networks/samitha1onrampbig.json');

uoff = noControlU(scen);
utest = uoff;
utest(:,5) = .1;

% totalTravelTime(scen , uoff)
% totalTravelTime(scen , utest)
% 
% os1 = forwardSimulation(scen, uoff);
% os2 = forwardSimulation(scen, utest);
% 
% sum(sum(os1.density)) + sum(sum(os1.queue))
% sum(sum(os2.density)) + sum(sum(os2.queue))


%plotting.plotSimDifference(os1, os2);

% u_perturb = max(utest + randn(size(utest)), 0)
u_perturb = utest;
%u_perturb(1,2) = 0.05;
u_perturb
figure(1)
ustar = rampOptimalU(scen, u_perturb,true)

figure;
global u_rho_l;
plot(u_rho_l);

os3 = forwardSimulation(scen, ustar);
% us3 = ustar
sum(sum(os3.density)) + sum(sum(os3.queue))
os3.density
os3.queue
% figure;
% plot(u12);
%plotting.plotSimDifference(os2, os3);

%ustar(1,2) = .1;

% figure(2)
% ustar = rampOptimalU(scen, ustar,true);
% 
% os4 = forwardSimulation(scen, ustar);
% us4 = ustar
% sum(sum(os4.density)) + sum(sum(os4.queue))
% 
% %plotting.plotSimDifference(os2, os4);
% 

os4 = forwardSimulation(scen, uoff);
sum(sum(os4.density)) + sum(sum(os4.queue))
os4.density
os4.queue

plotting.spaceTimePlot(os3.density - os4.density, true);
plotting.spaceTimePlot(os3.queue - os4.queue, true);
plotting.plotForwardSim(scen, uoff);
plotting.plotForwardSim(scen, ustar);
end