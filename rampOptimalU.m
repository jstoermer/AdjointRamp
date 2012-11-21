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
state = morphU(@forwardSimulation,scen, 2);
cost = morphU(@totalTravelTime, scen, 3);
fns = rampPartialFunctions;
dhdx = morphU(fns.dhdx,scen, 3);
djdx = morphU(fns.djdx,scen, 3);
dhdu = morphU(fns.dhdu,scen, 3);
djdu = morphU(fns.djdu,scen, 3);

u = unstack(adjointOptimization(scen, stacker(u0), state, cost, dhdx, djdx, djdu, dhdu, descent), scen);
outputState = forwardSimulation(scen, u);
end