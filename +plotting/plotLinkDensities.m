function plotLinkDensities(states)
plotInfo = struct('xLabel', 'Downstream', 'yLabel', 'Time', 'title', 'Link Densities');
plotting.spaceTimePlot(states.density, plotInfo);
end