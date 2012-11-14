function out = costFunctionBFGS(u)
global bfgsStore;
scen = bfgsStore.scen;
umat = unstack(u, scen);
states = forwardSimulation(scen, umat);
bfgsStore.states = states;
out = totalTravelTime(scen, states, umat);
end