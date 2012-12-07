function saveScenario(varargin)
scen = varargin{1};
if nargin == 2
    fn = varargin{2};
else
    fn = ['networks/' datestr(clock) '.json'];
end
savejson('',scen, fn);
end