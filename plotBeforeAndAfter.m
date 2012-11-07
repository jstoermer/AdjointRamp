function plotBeforeAndAfter(fn)
s1 = loadJSONScenario(fn);
plotForwardSim(s1);
s2 = loadJSONScenario(fn);
optimalU = getOptimalMetering(s2);
s2.u = optimalU;
plotForwardSim(s2);
plotSimDifference(s1,s2);
end