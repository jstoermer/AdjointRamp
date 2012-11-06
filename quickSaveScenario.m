function quickSaveScenario(varargin)
scen = varargin{1};
if nargin == 2
    fn = varargin{2};
else
    fn = ['networks/' datestr(clock) '.json'];
end

try
    u = scen.u;
    json.u = u;
    scen = rmfield(scen, 'states');
    scen = rmfield(scen, 'state');
    scen = rmfield(scen, 'dummy');
    scen = rmfield(scen, 'u');
    scen = rmfield(scen, 'iter');
catch e
    disp(e);
end
json.scen = scen;
json.type = 1;
savejson('',json, fn);
disp('howdy')
end