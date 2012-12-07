close all; clc;
loadParameters;
scen = loadScenario('networks/samitha1onramp.json');
u1 = ones(size(scen.BC.D));
os1 = forwardSimulation(scen, u1);

u2 = u1;
u2(1:3,2) = .12;


os2 = forwardSimulation(scen, u2);

plotSimDifference(os1, os2);