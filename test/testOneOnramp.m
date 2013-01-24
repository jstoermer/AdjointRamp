function testOneOnramp
close all
scen = io.loadScenario('../networks/samitha1onramp.json');

uoff = ones(scen.T, scen.N);
utest = ones(scen.T, scen.N);
utest(:,2) = .1;

totalTravelTime(scen , uoff)
totalTravelTime(scen , utest)

os1 = forwardSimulation(scen, uoff);
os2 = forwardSimulation(scen, utest);

plotting.plotSimDifference(os1, os2);

% u_perturb = max(utest + randn(size(utest)), 0)
u_perturb = utest.*.1

ustar = rampOptimalU(scen, u_perturb)

os3 = forwardSimulation(scen, ustar);

plotting.plotSimDifference(os2, os3);

ustar(1,2) = .1;

ustar = rampOptimalU(scen, ustar)

os3 = forwardSimulation(scen, ustar);

plotting.plotSimDifference(os2, os3);




end