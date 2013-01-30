function out = noControlU(scen)
fs  = forwardSimulation(scen, chooseInitialU(scen, 1.1));

queues = fs.queue;
rmaxes = repmat([scen.links.rmax], scen.T, 1);

out = min(queues(1:end-1, :) ./ scen.dt, rmaxes);
end