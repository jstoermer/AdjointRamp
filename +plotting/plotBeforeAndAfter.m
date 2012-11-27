function plotBeforeAndAfter(varargin)
[scen, u1] = scenUVarArgIn(varargin);
u1
os1 = plotForwardSim(scen, u1);
u2 = rampOptimalU(scen)
os2 = plotForwardSim(scen, u2);
plotSimDifference(os1, os2);
end