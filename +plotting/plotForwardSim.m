function out = plotForwardSim(varargin)
[scen, u] = scenUVarArgIn(varargin);
states = forwardSimulation(scen, u);
plotLinkDensities(states);
plotQueueLengths(states);
out = states;
end