clear all; clc; close all;
loadParameters;
global parameters;
scen = loadScenario('networks/samitha1onramp.json');
% N = scen.N; T = scen.T;
optimalU(scen)
% plotBeforeAndAfter(scen, u);
% totalTravelTime(scen, optimalU(scen, u))