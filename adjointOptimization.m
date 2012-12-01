function out = adjointOptimization(data, u0, state, cost, dhdx, djdx, dhdu, djdu, descent)
s = adjointStructure(data, state, cost, dhdx, djdx, dhdu, djdu);
s.updateStates(u0);
out = descent(u0, s.objective, s.gradient);
end