function out = loadJSONScenario(json_file)
json = loadjson(json_file);
if isfield(json, 'scen')
    out = loadJSONScenarioWithControl(json_file);
    return;
end
N = length(json.v);
T = length(json.D0);
u = ones(T,N)*10000000;
out = loadJSONScenarioWithControl(json, u);
end