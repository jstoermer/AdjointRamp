function [myScenario, outputState] = createScenario(numLinks, numTimeSteps)

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

D = rand(numTimeSteps, numLinks);
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

u = chooseInitialU(myScenario);

low = 1;
high = numTimeSteps;
i = 0;

% TODO: WHILE LOOP IS NOT TERMINATING CORRECTLY. MAXIMUM RUNNING TIME FOR
% BINARY SEARCH IS LOG2(N).

% TODO: MAKE DEMAND PROFILE "SMOOTH", RATHER THAN RANDOM.

while (low <= high)
    i = i + 1
    mid = floor((low + high) / 2);
    testD = [D(1:mid, :); zeros(numTimeSteps - mid, numLinks)];
    myScenario.BC.D = testD;
    outputState = forwardSimulation(myScenario, u);
    outputState.density
    if sum(outputState.density(end, :)) > 1e-4
        high = mid;
    elseif sum(outputState.density(end - 1, :)) < 1e-4
        low = mid;
    else
        return;
    end % end if
end % end while (low <= high)

end % end createScenario