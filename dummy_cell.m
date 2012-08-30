function out = dummy_cell()
v = 1;
L = 1;
w = 1;
f_max = 10000000000;
out = highway_cell(v,w,f_max, L);
out = init_state(out,0,0);
out.state_demand = @() out.demand(out.state);
end