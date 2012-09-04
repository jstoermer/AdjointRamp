function out = forward_sim(scenario)
s = scenario;
if length(s.rho_0) > s.N
    dummyrho = s.rho_0(1);
    s.rho_0 = s.rho_0(2:end);
else
    dummyrho = 0.0;
end
s = init_scenario(s);
states = init_state_collector();
s.state = init_state_collector();
s.dummy.state.rho = dummyrho;
s.state(1).densities(1) = s.dummy.state.rho;
for i = 1:s.N-1
    s.state.densities(i+1) = s.cells(i).state.rho;
    s.state.ramp_queues(i) = s.cells(i).state.l;
end
s.state(1).densities(end+1) = s.cells(end).state.rho;
states = store_states(s, states);

for t = 1:s.T
    s = scen_update_props(s, t);
    s = forward_sim_one_step(s);
    states = store_states(s, states);
end

s.states = states;

out = s;
end