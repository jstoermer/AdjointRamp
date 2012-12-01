function out = plotForwardSim(varargin)
[scen, u] = scenUVarArgIn(varargin);
states = forwardSimulation(scen, u);
plotting.plotLinkDensities(states);
plotting.plotQueueLengths(states);
plotUPenalty(scen, u);
out = states;
end