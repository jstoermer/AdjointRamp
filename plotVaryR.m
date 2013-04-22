function varargout = plotVaryR(varargin)
% PURPOSE:
% plotVaryU plots the controlled total travel times (TTT) for the given
% scenario, with varying initial values for R. Uses rampOptimalUvarR, with
% 5 iterations and 0.1 step scaling.
%
% INPUTS:
% 1. jsonScen: A scenario, provided in the JSON format.
% 2. (Optional) numTrials: The number of trials to be plotted. If no
%    argument is provided, it will default to 5.
% 3. (Optional) initR: Starting value for R. If no argument is provided, it 
%    will default to 1.
% 4. (Optional) stepSize: The step size for increasing R. If no argument is
%    provided, it will default to 0.1.
%
% OUTPUTS:
% 1. (Optional) varyR: An array of the varying values for R.
% 2. (Optional) controlTTT: An array of the TTT, corresponding to varyR.

global parameters;

prevR = parameters.R;

jsonScen = varargin{1};
numTrials = 5;
initR = 1;
stepSize = 0.1;

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
controlU = 0.5 * noControlU(jsonScen);

for i = 1:numTrials
    startR = initR * (stepSize)^(i-1);
    varyR(i) = startR;
    parameters.R = startR;
    u = noControlU(jsonScen);
    controlU = rampOptimalUvarR(5, 0.1, jsonScen, controlU);
    outState = forwardSimulation(jsonScen, u);
    controlOutState = forwardSimulation(jsonScen, controlU);
    TTT(i) = findTTT(jsonScen, outState);
    controlTTT(i) = findTTT(jsonScen, controlOutState);
end % end for i

semilogx(varyR, TTT, 'o-', varyR, controlTTT, 'o-');
xlabel('Initial R');
ylabel('Total Travel Time');
title('Total Travel Time Vs. Initial R');
legend('Total Travel Times, No Control', 'Total Travel Times, Control');

minTTT = find(TTT == min(TTT));
minTTT = minTTT(end);
hold on;
plot(varyR(minTTT), controlTTT(minTTT), 'r*');
hold off;

varargout{1} = varyR;
varargout{2} = controlTTT;

parameters.R = prevR;

end % end plotVaryU