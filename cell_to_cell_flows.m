function out = cell_to_cell_flows(us_cell, ds_cell)
    beta = us_cell.props.beta;
    us_demand = demand(us_cell);
    ramp_dem = ramp_demand(us_cell);
    ds_supply = supply(ds_cell);
    f_in = min(us_demand * (1 - beta) + ramp_dem, ds_supply);
    f_out = flow_out(us_cell, f_in, us_demand, ramp_dem);
    ramp_flow = f_in - (1 - beta) * f_out;
    out.demand = us_demand;
    out.supply = ds_supply;
    out.ramp_demand = ramp_dem;
    out.flow_in = f_in;
    out.flow_out = f_out;
    out.ramp_flow = ramp_flow;
end