function myPenalty = uPenalty(varargin)

global parameters;
R = parameters.R;
myScenario = varargin{1};

if nargin == 2
    u = varargin{2};
    myStates = forwardSimulation(myScenario, u);
    myQueue = myStates.queue;
else
    myQueue = varargin{2};
    u = varargin{3};
end

dt = myScenario.dt;
rMax  = repmat([myScenario.links.rmax], myScenario.T, 1);
l = myQueue(1:(end - 1), :);

myPenalty = 3 * R .* (max(u - min(l ./ dt, rMax), 0)).^3;

end % end myPenalty