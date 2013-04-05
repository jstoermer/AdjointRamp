function plotBeforeAndAfter(varargin)

[scen, u1] = scenUVarArgIn(varargin);
% myFigure = figure();
% plotInfo = struct('currIter', 1, 'totalIter', 2, 'parentFigure', myFigure);
os1 = plotting.plotForwardSim(scen, u1); % Previously (scen, u1, plotInfo).
u2 = rampOptimalU(scen, u1);
%plotInfo.currIter = 2;
os2 = plotting.plotForwardSim(scen, u2); % Previously (scen, u2, plotInfo).
%plotting.plotSimDifference(os1, os2);

end