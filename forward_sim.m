function out = forward_sim(scenario)
s = scenario;
s = init_scenario(s);
states = init_state_collector();
s.state = init_state_collector();
s.state(1).densities(1) = s.dummy.state.rho;
s.state.ramp_queues(1) = s.dummy.state.l;
for i = 1:s.N
    s.state.densities(i+1) = s.cells(i).state.rho;
    s.state.ramp_queues(i+1) = s.cells(i).state.l;
end
states = store_states(s, states);

for t = 1:s.T
    s = scen_update_props(s, t);
    s = forward_sim_one_step(s);
    states = store_states(s, states);
end

out = states;
end