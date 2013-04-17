function u = chooseInitialU(varargin)
global parameters;
scen = varargin{1};
if nargin == 2
  factor = varargin{2};
else
  factor = parameters.defaultUScale;
end


u = noControlU(scen).*factor;

end
