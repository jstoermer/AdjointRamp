function [u, outputState] = rampOptimalU(varargin)
% Computes the optimal ramp metering control for a given scenario
% Inputs
% varargin(1) - JSON description of a scenario or the scenario structure
% varargin(2) - (optional) Initial control
% Outputs
% u - Optimal control 
% outputState - State evolution resulting from the optimal control

global parameters;
[scen u0] = scenUVarArgIn(varargin);
descent = parameters.globalDescentAlgorithm;
s = rampAdjointStructures(scen);

u = unstack(adjointOptimization(scen, stacker(u0), s.state, s.cost, s.dhdx, s.djdx, s.dhdu, s.djdu, descent), scen);
outputState = forwardSimulation(scen, u);
end