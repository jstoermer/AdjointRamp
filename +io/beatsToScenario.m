function out  = beatsToScenario(fn)

temp_out = 'tempxxxxxx.json';

io.convertBeatsToJSON(fn, temp_out);

out = io.loadScenario(temp_out);

!rm tempxxxxxx.json
end