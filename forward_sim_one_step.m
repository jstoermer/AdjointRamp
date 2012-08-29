function scen = forward_sim_one_step(scen)
N = scen.N;
flow_0 = dummy_flow_out(scen);
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

s_state = init_state_collector();
s_state(1).demands(1) = demand(scen.dummy);
s_state.supplies(1) = supply(scen.cells(1));
s_state.densities(1) = scen.dummy.state.rho;
s_state.flow_ins(1) = flow_0;
s_state.flow_outs(1) = flow_0;
for i = 1:N-1
    s_state.ramp_demands(i) = flows(i).ramp_demand;
    s_state.ramp_flows(i) = flows(i).ramp_flow;
    s_state.ramp_queues(i) = scen.cells(i).state.l;
    
    s_state.demands(i+1) = flows(i).demand;
    s_state.supplies(i+1) = flows(i).supply;
    s_state.densities(i+1) = scen.cells(i).state.rho;
    s_state.flow_ins(i+1) = flows(i).flow_in;
    s_state.flow_outs(i+1) = flows(i).flow_out;
end
s_state.demands(end+1) = flow_N;
s_state.densities(end+1) = scen.cells(end).state.rho;

scen.state = s_state;
    
end

    