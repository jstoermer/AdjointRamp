function varargout = plotVaryR(varargin)
% PURPOSE:
% plotVaryU plots the controlled total travel times (TTT) for the given
% scenario, with varying values for R.
%
% INPUTS:
% 1. jsonScen: A scenario, provided in the JSON format.
% 2. (Optional) numTrials: The number of trials to be plotted. If no
%    argument is provided, it will default to 5.
% 3. (Optional) initR: Initial value for R. If no argument is provided, it 
%    will default to 0.1.
% 4. (Optional) stepSize: The step size for increasing R. If no argument is
%    provided, it will default to 0.2.
%
% OUTPUTS:
% 1. (Optional) varyR: An array of the varying values for R.
% 2. (Optional) controlTTT: An array of the TTT, corresponding to varyR.

global parameters

jsonScen = varargin{1};
numTrials = 5;
initR = 0.1;
stepSize = 0.2;

if length(varargin) == 2
    numTrials = varargin{2};
elseif length(varargin) == 3
    numTrials = varargin{2};
    initR = varargin{3};
elseif length(varargin) == 4
    numTrials = varargin{2};
    initR = varargin{3};
    stepSize = varargin{4};
end % end if

varyR = zeros(1, numTrials);
TTT = zeros(1, numTrials);
controlTTT = zeros(1, numTrials);
previousU = chooseInitialU(jsonScen);

for i = 1:numTrials
    currR = initR + (i-1)*stepSize;
    varyR(i) = currR;
    parameters.R = currR;
    u = noControlU(jsonScen);
    controlU = rampOptimalU(jsonScen, previousU);
    outState = forwardSimulation(jsonScen, u);
    controlOutState = forwardSimulation(jsonScen, controlU);
    TTT(i) = findTTT(jsonScen, outState);
    controlTTT(i) = findTTT(jsonScen, controlOutState);
    previousU = controlU;
end % end for i

plot(varyR, TTT, 'o-', varyR, controlTTT, 'o-');
xlabel('R');
ylabel('Total Travel Time');
title('Total Travel Time Vs. R');
legend('Total Travel Times, No Control', 'Total Travel Times, Control');

varargout{1} = varyR;
varargout{2} = controlTTT;

end % end plotVaryU