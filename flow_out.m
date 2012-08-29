function out = flow_out(us_cell, flow_in, cell_dem, ramp_dem)
% HACK
p = .5;
beta = us_cell.props.beta;
if us_cell.props.beta == 0
    if p/(1-p) > cell_dem / (flow_in - (1 - beta)*cell_dem)
        out = cell_dem;
    elseif p/(1-p) < (flow_in - ramp_dem) / ((1 - beta)*ramp_dem)
        out = flow_in - ramp_dem / (1 - beta);
    else
        out = p * flow_in / (1 - beta);
    end
else
    if flow_in < (1 - beta) * cell_dem
        out = flow_in / (1 - beta);
    else
        out = cell_dem;
    end
end     
end