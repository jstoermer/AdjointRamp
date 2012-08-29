function scen = forward_sim_one_step(scen)
N = scen.N;
flow_0 = dummy_flow_out(scen)
flow_N = demand(scen.cells(N));
for i = 1:N-1
    flows(i) = cell_to_cell_flows(scen.cells(i), scen.cells(i+1));
end

dt = scen.dt;
dx = scen.dx;

scen.dummy.state.rho = next_density(scen.dummy.state.rho,scen.dummy.props.D,flow_0,dt,dx);

for i = 1:N-1
    if i == 1
        flow_in = flow_0;
    else
        flow_in = flows(i-1).flow_in;
    end
    ramp_flow = flows(i).ramp_flow;
    flow_out = flows(i).flow_out;
    cell = scen.cells(i);
    cell.state.rho = next_density(cell.state.rho, flow_in,flow_out, dt,dx);
    cell.state.l = next_ramp_state(cell.state.l, cell.props.D, ramp_flow, dt);
    scen.cells(i) = cell;
end

last_cell = scen.cells(end);

last_cell.state.rho = next_density(last_cell.state.rho, flows(end).flow_in, flow_N, dt,dx);
scen.cells(end) = last_cell;
end

    