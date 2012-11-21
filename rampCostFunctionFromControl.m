function out = rampCostFunctionFromControl(u)
global rampStore;
scen = rampStore.scen;
umat = unstack(u, scen);
states = forwardSimulation(scen, umat);
rampStore.states = states;
out = totalTravelTime(scen, states, umat);
end