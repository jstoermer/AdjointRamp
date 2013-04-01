function myPenalty = uPenalty(varargin)

global parameters;
R = parameters.R;

if (nargin >= 2)
    myScenario = varargin{1};
else
    error('Too few arguments. Needs at least a scenario and a matrix for u.');
end % end if (nargin >= 2)

if (nargin == 2)
    u = varargin{2};
    myStates = forwardSimulation(myScenario, u);
    myQueue = myStates.queue;
elseif (nargin == 3)
    myQueue = varargin{2};
    u = varargin{3};
else
    error('Too many arguments. Can have at most a scenario, a matrix for queue lengths, and a matrix for u.');
end % end if (nargin == 2)

dt = myScenario.dt;
rMax  = repmat([myScenario.links.rmax], myScenario.T, 1);
l = myQueue(1:(end - 1), :);

%myPenalty = 2 * R .* (max(u - min(l ./ dt, rMax), 0)).^2;
myPenalty = R * barrierMax(u, .1 + min(rMax, l));

end % end myPenalty