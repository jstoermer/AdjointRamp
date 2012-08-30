function out = flow_out(us_cell, flow_in, cell_dem, ramp_dem)
% HACK
p = .2;
beta = us_cell.props.beta;
if us_cell.props.beta == 0
    if flow_in > cell_dem / p
        out = cell_dem;
    elseif flow_in > ramp_dem / (1 - p)
        out = flow_in - ramp_dem;
    else
        out = p * flow_in;
    end
else
    if flow_in < (1 - beta) * cell_dem
        out = flow_in / (1 - beta);
    else
        out = cell_dem;
    end
end     
end