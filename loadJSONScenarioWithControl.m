function out = loadJSONScenarioWithControl(varargin)
json_file = varargin{1};
if isstruct(json_file)
    json = json_file;
else
    json = loadjson(json_file);
end
if length(varargin) == 2
    u = varargin{2};
else
    u = json.u;
end
scen = json_2_scen(json);
scen.u = u;

out = scen;
end