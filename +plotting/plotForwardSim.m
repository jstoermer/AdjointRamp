function outputStates = plotForwardSim(varargin)
% The last argument may be a struct containing the current iteration, the 
% total number of iterations, and a figure. For use in plotBeforeAndAfter.m.

if isstruct(varargin{end})
    plotInfo = varargin{end};
    varargin(end) = [];
    
    currIter = plotInfo.currIter;
    totalIter = plotInfo.totalIter;
    myFigure = plotInfo.parentFigure;
    
else
    currIter = 1;
    totalIter = 1;
    myFigure = figure();
end

[myScenario, u] = scenUVarArgIn(varargin);
myStates = forwardSimulation(myScenario, u);

plotWidth = (1 - 0.075*totalIter)/totalIter;
plotLeft = 0.075*currIter + (currIter - 1)*plotWidth;

linkDensities_axesHandle = axes('Parent', myFigure, 'Position', [plotLeft, 0.741, plotWidth, 0.183]);
plotting.plotLinkDensities(myStates, linkDensities_axesHandle);

queueLength_axesHandle = axes('Parent', myFigure, 'Position', [plotLeft, 0.408, plotWidth, 0.183]); 
plotting.plotQueueLengths(myStates, queueLength_axesHandle);

uPenalty_axesHandle = axes('Parent', myFigure, 'Position', [plotLeft, 0.075, plotWidth, 0.183]);
plotting.plotUPenalty(myStates, uPenalty_axesHandle);

outputStates = myStates;

end