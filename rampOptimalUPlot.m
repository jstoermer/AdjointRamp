function [] = rampOptimalUPlot(varargin)

scen = varargin{1};

if (length(varargin) > 1)
    initControl = varargin{2};
    
end % end if

rampOptimalU(varargin);

end % end rampOptimalUPlot