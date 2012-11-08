function out = loadJSONScenarioWithControl(varargin)
json = jsonOrScen(varargin{1});
if length(varargin) == 2
    u = varargin{2};
else
    u = json.u;
end
scen = json_2_scen(json);
scen.u = u;

out = scen;
end