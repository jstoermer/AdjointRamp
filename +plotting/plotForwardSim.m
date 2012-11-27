function out = plotForwardSim(varargin)
[scen, u] = scenUVarArgIn(varargin);
states = forwardSimulation(scen, u);
plotting.plotLinkDensities(states);
plotting.plotQueueLengths(states);
out = states;
end