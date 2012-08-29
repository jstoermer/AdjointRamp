function out = forward_sim(scenario)
s = scenario;
s = init_scenario(s);
states = init_state_collector();
states = store_states(s, states);

for t = 1:s.T
    s = scen_update_props(s, t);
    s = forward_sim_one_step(s);
    states = store_states(s, states);
end

out = states;
end