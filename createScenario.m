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
p = 0.8 .* ones(1, numLinks);
rmax = 0.5 + 0.5 .* rand(1, numLinks);
L = ones(1, numLinks);
pc = fm ./ v;
pm = fm ./ w + pc;

% The demand profile will follow a Gaussian distribution.
X = linspace(-2, 2, numTimeSteps);
Y = exp(-0.5*X.^2);

D = zeros(numTimeSteps, numLinks);
for i = 1:numLinks
    D(:, i) = 0.1*rand(numTimeSteps, 1) + Y(1:end)';
end % end for i = 1:numTimeSteps
beta = 0.1 .* ones(numTimeSteps, numLinks) + 0.9 .* rand(numTimeSteps, numLinks);
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

% TODO: MAKE DEMAND PROFILE "SMOOTH", RATHER THAN RANDOM.

% Binary search to find the optimal demand matrix, ensuring that the
% network is cleared and minimizing the number of time steps that have no
% densities.

u = chooseInitialU(myScenario);
low = 1;
high = numTimeSteps;

while (low <= high)
    mid = floor((low + high) / 2);
    if (mid == low || mid == high)
        return;
    end % end if
    X = linspace(-2, 2, mid);
    Y = exp(-0.5*X.^2);
    D = zeros(numTimeSteps, numLinks);
    for i = 1:numLinks
        D(1:mid, i) = 0.1*rand(mid, 1) + Y(1:end)';
    end % end for i = 1:numTimeSteps
    myScenario.BC.D = D;
    outputState = forwardSimulation(myScenario, u);
    if sum(outputState.density(end, :)) > 1e-4;
        high = mid;
    elseif sum(outputState.density(end - 1, :)) < 1e-8;
        low = mid;
    else
        return;
    end % end if
end % end while (low <= high)

end % end createScenario