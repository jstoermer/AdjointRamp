function plotForwardSim(scen)
scen = jsonOrScen(scen);
scen = forward_sim(scen);
plotLinkDensities(scen);
end