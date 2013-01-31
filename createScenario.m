function [myScenario] = createScenario(varargin)

% Generates a nontrivial scenario, provided the number of links and the
% number of time steps.

% ARGUMENTS:
% numLinks: Number of links.
% numTimeSteps: Number of time steps.
% (Optional) distrStruct: Struct of distributions for variables. See
% createDistrStruct for possible fields and values.

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

numLinks = varargin{1};
numTimeSteps = varargin{2};

if length(varargin) > 2
    infoStruct = varargin{3};
end % end if length(varargin) > 2

w = 0.5 + 0.5 .* rand(1, numLinks);
v = ones(1, numLinks);
fm = 0.5 + 0.5 .* rand(1, numLinks);
p = 0.8 .* ones(1, numLinks);
rmax = 0.5 + 0.5 .* rand(1, numLinks);
L = ones(1, numLinks);
pc = fm ./ v;
pm = fm ./ w + pc;

D = zeros(numTimeSteps, numLinks);
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

% Binary search to find the optimal demand matrix, ensuring that the
% network is cleared and minimizing the number of time steps that have no
% densities.

u = chooseInitialU(myScenario);
lowBound = 1;
highBound = numTimeSteps;

while (lowBound <= highBound)
    midBound = floor((lowBound + highBound) / 2);
    
    % Terminates the loop if a "perfect" demand profile cannot be
    % generated, i.e. neither of the termination conditions can be 
    % satisfied. Returns the current optimal demand profile.
    if (midBound == lowBound || midBound == highBound)
        % disp(outputState.density);
        return;
    end % end if
    
    % The nonzero demands will follow a "noisy" Gaussian distribution with
    % respect to time.
    D = zeros(numTimeSteps, numLinks);
    X = linspace(-2, 2, midBound);
    Y = exp(-0.5*X.^2);
    
    for i = 1:numLinks
        D(1:midBound, i) = 0.1*rand(midBound, 1) + Y(1:end)';
    end % end for i = 1:numTimeSteps
    
    myScenario.BC.D = D;
    outputState = forwardSimulation(myScenario, u);
    
    if sum(outputState.density(end, :)) > 1e-8;
        highBound = midBound;
    elseif sum(outputState.density(end - 1, :)) < 1e-8;
        lowBound = midBound;
    else
        % disp(outputState.density);
        return;
    end % end if
    
end % end while (lowBound <= highBound)



end % end createScenario