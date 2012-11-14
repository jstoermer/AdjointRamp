function out =  gradientBFGS(u)
global bfgsStore;
states = bfgsStore.states;
scen = bfgsStore.scen;
umat = unstack(u,scen);
bfgs.states = states;
out = gradientRampControl(scen, states, umat);
end