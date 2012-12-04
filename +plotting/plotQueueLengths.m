function plotQueueLengths(states)
plotInfo = struct('xLabel', 'Downstream', 'yLabel', 'Time', 'title', 'Queue Lengths');
plotting.spaceTimePlot(states.queue, plotInfo);
end