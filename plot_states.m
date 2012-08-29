function plot_states(states)

T = length(states);
N = length(states(1).densities);

for i = 1:T
    for j = 1:N
        data(j,i,1) = states(i).densities(j);
    end
    for j = 1:N-2
        data(j,i,2) = states(i).ramp_queues(j);
    end
end

plt(1:T,data(:,:,1));
plt(1:T,data(:,:,2));
        