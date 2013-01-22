function varargout = adjointOptimization(data, u0, state, cost, dhdx, djdx, dhdu, djdu, descent)
s = adjointStructure(data, state, cost, dhdx, djdx, dhdu, djdu);
s.updateStates(u0);
[out, cost] = descent(u0, s.objective, s.gradient);
varargout{1} = out;
varargout{2} = cost;
end