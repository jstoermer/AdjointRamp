function [] = plotUPenalty(states)
plotInfo = struct('xLabel', 'Downstream', 'yLabel', 'Time', 'title', 'Penalty To U');
plotting.spaceTimePlot(states.uPenalty, plotInfo);
end % end plotUPenalty