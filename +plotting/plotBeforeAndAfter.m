function plotBeforeAndAfter(varargin)
[scen, u1] = scenUVarArgIn(varargin);
u1;
os1 = plotting.plotForwardSim(scen, u1);
u2 = rampOptimalU(scen);
os2 = plotting.plotForwardSim(scen, u2);
plotting.plotSimDifference(os1, os2);
end