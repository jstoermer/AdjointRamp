function varargout = adjointOptimization(data, u0, state, cost, dhdx, djdx, dhdu, djdu, descent)
s = adjointStructure(data, state, cost, dhdx, djdx, dhdu, djdu);
s.updateStates(u0);
try
  [out, cst] = descent(u0, s.objective, s.gradient);
catch e
  out = descent(u0, s.objective, s.gradient);
  cst = 0;
end
varargout{1} = out;
varargout{2} = cst;
varargout{3} = s;
end