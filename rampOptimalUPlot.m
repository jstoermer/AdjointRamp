function [] = rampOptimalUPlot(varargin)

scen = varargin{1};

if (length(varargin) == 1)
    rampOptimalU(scen, true);
elseif (length(varargin) == 2)
    initCont = varargin{2};
    rampOptimalU(scen, initCont, true);
else
    error('Incorrect number of arguments. rampOptimalUPlot can have at most two arguments, e.g. a scenario and an initial control.');
end % end if

end % end rampOptimalUPlot