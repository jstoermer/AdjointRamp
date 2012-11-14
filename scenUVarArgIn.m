function [scen, u] = scenUVarArgIn(varargin)
cellargs = varargin{1};
scen = loadScenario(cellargs{1});
if length(cellargs) == 2
  u = cellargs{2};
else
  if nargin == 2
    u = chooseInitialU(scen, varargin{2});
  else
    u = chooseInitialU(scen);
  end
end
end
