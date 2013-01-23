function varargout = rampOptimalU(varargin)
% Computes the optimal ramp metering control for a given scenario
% Inputs
% varargin(1) - JSON description of a scenario or the scenario structure
% varargin(2) - (optional) Initial control
% varargin(3) - (optional) Logical for cost plot
% Outputs
% u - Optimal control 
% outputState - State evolution resulting from the optimal control

plotCost = false;
 
if islogical(varargin{end})
    plotCost = varargin{end};
    varargin(end) = [];
end % if islogical(varargin{end})

global parameters;
[scen, u0] = scenUVarArgIn(varargin);
descent = parameters.globalDescentAlgorithm;
s = rampAdjointStructures(scen);

[u, totCost] = adjointOptimization(scen, stacker(u0), s.state, s.cost, s.dhdx, s.djdx, s.dhdu, s.djdu, descent);
u = unstack(u, scen);
outputState = forwardSimulation(scen, u);
varargout{1} = u;
varargout{2} = outputState;
varargout{3} = totCost;

if plotCost
    plot(totCost);
    title('Total Cost vs. Iteration');
    xlabel('Iteration');
    ylabel('Total Cost');
end % end if plotCost

end