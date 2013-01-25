function [myScenario] = createScenario(numLinks, numTimeSteps)

% Generates a nontrivial scenario, provided the number of links and the
% number of time steps.

% w: Wave speed.
% v: Free-flow speed.
% fm: Maximum flow.
% p: Priority.
% rmax: Maximum ramp outflow.
% L: Link length.
% pc: Critical density.
% pm: Jam density.
% D: Demands.
% beta: Split ratios.
% l0: Initial queues.
% p0: Initial densities.

w = 0.5 + 0.5 .* rand(1, numLinks);
v = ones(1, numLinks);
fm = 0.5 + 0.5 .* rand(1, numLinks);
p = rand(1, numLinks);
rmax = 0.5 + 0.5 .* rand(1, numLinks);
L = ones(1, numLinks);
pc = fm ./ v;
pm = fm ./ w + pc;

% TODO: ADD FORWARD SIMULATIONS TO ADJUST CLEAR TIME.  

if numTimeSteps > clearTime
    D = [rand(numTimeSteps - clearTime, numLinks); zeros(clearTime, numLinks)];
else
    D = zeros(numTimeSteps, numLinks);
end % end if numTimeSteps > numLinks

beta = rand(numTimeSteps, numLinks);
BC = struct('D', D, 'beta', beta);

l0 = rand(1, numLinks);
p0 = rand(1, numLinks);
IC = struct('l0', l0, 'p0', p0);

myLinks = [];

for i = 1:numLinks
    currLink = struct('w', w(i), 'v', v(i), 'fm', fm(i), 'p', p(i), ...
        'rmax', rmax(i), 'L', L(i), 'pc', pc(i), 'pm', pm(i));
    myLinks = [myLinks, currLink];
end % end for i = 1:numLinks

timeStepSize = 1; % Default value is 1.
nConstraints = (numTimeSteps + 1) * numLinks * 8;
nControls = numTimeSteps * numLinks;
processU = @(u)unstack(u,scen); % Default value is @(u)unstack(u,scen).

myScenario = struct('links', myLinks, 'BC', BC, 'IC', IC, 'N', numLinks, ...
    'T', numTimeSteps, 'dt', timeStepSize, 'nConstraints', nConstraints, ...
    'nControls', nControls, 'processU', processU);

end % end createScenario