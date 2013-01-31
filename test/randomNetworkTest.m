function randomNetworkTest

close all
global u12;

global parameters;
parameters.R =100;
parameters.alpha = .1;
parameters.globalMaxIterations = 300;
u12 = [];

N = 5;
T = 20;
scen = createScenario(N,T);

uoff = noControlU(scen);
utest = uoff.*.7;

% totalTravelTime(scen , uoff)
% totalTravelTime(scen , utest)
% 
% os2 = forwardSimulation(scen, utest);
% 
os1 = forwardSimulation(scen, uoff);
sum(sum(os1.density)) + sum(sum(os1.queue))
pause;
% sum(sum(os2.density)) + sum(sum(os2.queue))


%plotting.plotSimDifference(os1, os2);

% u_perturb = max(utest + randn(size(utest)), 0)
figure(1)
ustar = rampOptimalU(scen, utest,true)

figure;
global u_rho_l;
plot(u_rho_l);

os3 = forwardSimulation(scen, ustar);
% us3 = ustar
sum(sum(os3.density)) + sum(sum(os3.queue))
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



end