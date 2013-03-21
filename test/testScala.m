function testScala
clc; close all;
do_plot = false;
global parameters
global test_u
test_u = [];
colls = descentCollection;
parameters.globalDescentAlgorithm = colls.gdBasicPos;

parameters.R = .01;
parameters.globalMaxIterations = 400;
parameters.alpha = .1;
scen = io.loadScenario('../networks/samitha1onramp.json');
uoff = noControlU(scen);

u0 = uoff*.5;
ustar = rampOptimalU(scen, u0);

os4 = forwardSimulation(scen, ustar);
sum(sum(os4.density)) + sum(sum(os4.queue))
totalTravelTime(scen, os4, ustar)