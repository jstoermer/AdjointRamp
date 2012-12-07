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

% The following lines determine the positioning of the subplots and any
% adjustments to the titles of the subplots.
if (totalIter == 1)
    subplotWidth = 0.775;
    subplotLeft = 0.13;
    myTitle = '';
elseif (totalIter == 2)
    subplotWidth = 0.334659;
    if (currIter == 1)
        subplotLeft = 0.13;
        myTitle = ' Before \it{u}\rm Optimization';
    elseif (currIter == 2)
        subplotLeft = 0.570341;
        myTitle = ' After \it{u}\rm Optimization';
    end
end

linkDensities_axesHandle = axes('Parent', myFigure, 'Position', [subplotLeft, 0.709265, subplotWidth, 0.215735]);
plotting.plotLinkDensities(myStates, linkDensities_axesHandle, myTitle);

queueLength_axesHandle = axes('Parent', myFigure, 'Position', [subplotLeft, 0.409632, subplotWidth, 0.215735]);
plotting.plotQueueLengths(myStates, queueLength_axesHandle, myTitle);

uPenalty_axesHandle = axes('Parent', myFigure, 'Position', [subplotLeft, 0.11, subplotWidth, 0.215735]);
plotting.plotUPenalty(myStates, uPenalty_axesHandle, myTitle);

outputStates = myStates;

end