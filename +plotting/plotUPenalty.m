function [] = plotUPenalty(varargin)
% Primary argument is always a struct containing the parameters of the
% state. Optional argument is an axes handle, for use in plotForwardSim.m.

if nargin == 1
    myStates = varargin{1};
    plotInfo = struct('xLabel', 'Downstream', 'yLabel', 'Time', 'title', 'Penalty To U');
elseif nargin == 2
    myStates = varargin{1};
    axesHandle = varargin{2};
    plotInfo = struct('xLabel', 'Downstream', 'yLabel', 'Time', 'title', 'Penalty To U', 'axesHandle', axesHandle);
else
    error('Too many arguments. Can have at most a state struct and an axes handle.');
end % end if (nargin == 1)

plotting.spaceTimePlot(myStates.uPenalty, plotInfo);

end % end plotUPenalty