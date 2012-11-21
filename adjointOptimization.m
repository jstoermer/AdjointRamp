function out = adjointOptimization(data, u0, state, cost, dhdx, djdx, dhdu, djdu, descent)
clear statesStore;
global statesStore;
statesStore = false;
updateStates(u0);

  function updateStates(u)
    statesStore = state(data, u);
  end

  function out = getStates
    out = statesStore;
  end
      
  function out = gradient(u)
    states = getStates;
    out = adjointGradient(dhdx(data, states, u), djdx(data, states, u), dhdu(data, states, u), djdu(data, states, u));
  end

  function out = objective(u)
    updateStates(u);
    states = getStates;
    out = cost(data, states, u);
  end

out = descent(u0, @objective, @gradient);
end