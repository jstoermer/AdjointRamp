function out = getOptimalMetering(scen, useBFGS)
scen = jsonOrScen(scen);
if useBFGS
    out = adjointBFGS(scen, scen.u);
else
    out = adjoint_loopSamitha(scen, scen.u);
end
end