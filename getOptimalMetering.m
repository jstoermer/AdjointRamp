function out = getOptimalMetering(scen)
scen = jsonOrScen(scen);
out = adjointBFGS(scen, scen.u);
end