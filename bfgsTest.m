clc; close all;
loadParameters;
global parameters;
scen = loadScenario('networks/simple.json');
scen = loadScenario('networks/samitha1onramp.json');
% N = scen.N; T = scen.T;
plotBeforeAndAfter(scen);
% plotBeforeAndAfter(scen, u);
% totalTravelTime(scen, optimalU(scen, u))