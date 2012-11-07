function plotLinkDensities(scen)
data = datafy_states(scen.states);
densities = data(:,:,1)';
spaceTimePlot(densities);
end