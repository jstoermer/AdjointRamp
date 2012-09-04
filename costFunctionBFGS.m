function out = costFunctionBFGS(u)
global scen;
scen.u = reshapeUBFGS(u,scen);
scen = forward_sim(scen);
out = cost_function(scen);
end