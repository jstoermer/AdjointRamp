function samithaTest

close all
global u12;
u12 = [];
scen = io.loadScenario('../networks/samitha1onramp.json');

uoff = ones(scen.T, scen.N);
utest = ones(scen.T, scen.N);
utest(:,2) = .1;

totalTravelTime(scen , uoff)
totalTravelTime(scen , utest)

os1 = forwardSimulation(scen, uoff);
os2 = forwardSimulation(scen, utest);

sum(sum(os1.density)) + sum(sum(os1.queue))
sum(sum(os2.density)) + sum(sum(os2.queue))


%plotting.plotSimDifference(os1, os2);

% u_perturb = max(utest + randn(size(utest)), 0)
u_perturb = utest;
u_perturb(1,2) = 0.9;
u_perturb
figure(1)
ustar = rampOptimalU(scen, u_perturb,true);

os3 = forwardSimulation(scen, ustar);
us3 = ustar
sum(sum(os3.density)) + sum(sum(os3.queue))
figure;
plot(u12);
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