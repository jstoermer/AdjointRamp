function out = transfer_states(scen, main_scen, k)

if k == 0
    start = 1;
else
    start = 2;
end
main_scen.states = [main_scen.states, scen.states(start:end)];

out = main_scen;
end