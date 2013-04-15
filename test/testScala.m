function testScala
clc; close all;
global parameters
colls = descentCollection;
parameters.globalDescentAlgorithm = colls.gdBasicPos;
% parameters.globalDescentAlgorithm = colls.ipOptPos;


parameters.R = .01;
parameters.globalMaxIterations = 2000;
parameters.alpha = .5;
scen = io.loadScenario('../networks/samitha1onrampdt5.json');
uoff = noControlU(scen);
u0 = uoff;
ustar = rampOptimalU(scen, u0);

sim = forwardSimulation(scen, ustar);
sum(sum(sim.density)) + sum(sum(sim.queue))
totalTravelTime(scen, sim, ustar)