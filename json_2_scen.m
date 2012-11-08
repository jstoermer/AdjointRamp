function out = json_2_scen(json)
% note: this json is already parsed, see simulateJSON.m
try
    if json.type == 1
        out = json.scen;
        return;
    end
end
try
    data = json.scen;
catch
    data = json;
end

%% create cells
N = length(data.v);
for i = 1:N
    links(i).v = data.v(i);
    links(i).w = data.w(i);
    links(i).fm = data.fm(i);
end

%% scenario 1

scen = scenario(data.p0,data.l0,data.D0, data.D, cells, data.beta, data.p, data.dt, data.dx);
scen.R = data.R;



out = scen;
end