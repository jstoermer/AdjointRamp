function states = store_states(scen, states)
if length(states) == 1
    t = 1;
else
    t = size(states, 1) + 1;
end
states(t,1) = scen.dummy.state;
for i = 1:scen.N
    states(t,i+1) = scen.cells(i).state;
end
end