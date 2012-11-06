function out = jsonOrScen(scen)

if isstr(scen)
    out = loadJSONScenario(scen);
else
    out = scen;
end
end