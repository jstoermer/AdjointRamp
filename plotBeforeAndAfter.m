function plotBeforeAndAfter(fn)
s1 = loadScenario(fn);
% TODO: add function that allows for either some control or no control if
% no u
plotForwardSim(s1);
s2 = loadScenario(fn);
optimalU = optimalU(s2);
s2.u = optimalU;
plotForwardSim(s2);
plotSimDifference(s1,s2);
end