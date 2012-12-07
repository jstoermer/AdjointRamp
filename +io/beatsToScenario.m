function out  = beatsToScenario(fn)

temp_out = 'tempxxxxxx.json';

convertBeatsToJSON(fn, temp_out);

out = loadJSONScenario(temp_out);

!rm tempxxxxxx.json
end