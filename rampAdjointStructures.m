function out = rampAdjointStructures(scen)

out.state = morphU(@forwardSimulation,scen, 2);
out.cost = morphU(@totalTravelTime, scen, 3);
fns = rampPartialFunctions;
out.dhdx = morphU(fns.dhdx,scen, 3);
out.djdx = morphU(fns.djdx,scen, 3);
out.dhdu = morphU(fns.dhdu,scen, 3);
out.djdu = morphU(fns.djdu,scen, 3);

out.structure = adjointStructure(scen, out.state, out.cost, out.dhdx, out.djdx, out.dhdu, out.djdu);
end