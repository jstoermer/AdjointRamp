function out =  rampGradientFromControl(u)
global rampStore;
scen = rampStore.scen;
umat = unstack(u,scen);
if isfield(rampStore, 'states')
  states = rampStore.states;
else
  states = forwardSimulation(scen, umat);
end
out = gradientRampControl(scen, states, umat);
end