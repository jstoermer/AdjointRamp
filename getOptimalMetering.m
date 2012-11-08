function out = getOptimalMetering(scen, useBFGS)
scen = jsonOrScen(scen);
if useBFGS
    try
        out = adjointBFGS(scen, scen.u);
    catch e
        out = adjoint_loopSamitha(scen, scen.u);
    end
else
    out = adjoint_loopSamitha(scen, scen.u);
end
end