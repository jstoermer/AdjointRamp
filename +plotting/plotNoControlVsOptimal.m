function plotNoControlVsOptimal(varargin)
[scen, u1] = scenUVarArgIn(varargin);

noControl = noControlU(scen);

myFigure = figure();

plotInfo = struct('currIter', 1, 'totalIter', 2, 'parentFigure', myFigure);
os1 = plotting.plotForwardSim(scen, noControl, plotInfo);

u2 = rampOptimalU(scen, u1);

plotInfo.currIter = 2;
os2 = plotting.plotForwardSim(scen, u2, plotInfo);

plotting.plotSimDifference(os1, os2);

end