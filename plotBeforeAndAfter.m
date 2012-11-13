function plotBeforeAndAfter(varargin)
[scen, u1] = scenUVarArgIn(varargin, 1.1);

os1 = plotForwardSim(scen, u1);
u2 = optimalU(scen);
os2 = plotForwardSim(scen, u2);
plotSimDifference(os1, os2);
end