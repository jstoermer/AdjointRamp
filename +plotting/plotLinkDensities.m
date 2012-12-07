function plotLinkDensities(varargin)
% Primary argument is always a struct containing the parameters of the
% state. Optional arguments are an axes handle and a title, for use in plotForwardSim.m.

% If a parameter is not specified, it will be given a default value.
if (nargin == 1)
    myStates = varargin{1};
    plotInfo = struct('xLabel', 'Downstream', 'yLabel', 'Time', 'title', 'Link Densities');
elseif (nargin == 2)
    myStates = varargin{1};
    axesHandle = varargin{2};
    plotInfo = struct('xLabel', 'Downstream', 'yLabel', 'Time', 'title', 'Link Densities', 'axesHandle', axesHandle);
elseif (nargin == 3)
    myStates = varargin{1};
    axesHandle = varargin{2};
    myTitle = varargin{3};
    plotInfo = struct('xLabel', 'Downstream', 'yLabel', 'Time', 'title', strcat('Link Densities', myTitle), 'axesHandle', axesHandle);
else    
    error('Too many arguments. Can have at most a state struct, an axes handle, and a title.');
end % end if (nargin == 1)

plotting.spaceTimePlot(myStates.density, plotInfo);

end % end plotLinkDensities