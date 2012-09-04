function data = plot_states(states)
data = datafy_states(states);
T = length(states);
N = length(states(1).densities);
plt(1:T,data(:,:,1));
plt(1:T,data(:,:,2));
end