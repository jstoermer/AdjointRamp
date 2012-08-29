function plot_states(states)

T = size(states,1);
N = size(states,2);

for i = 1:N
    for j = 1:T
        data(i,j,1) = states(j,i).rho;
        data(i,j,2) = states(j,i).l;
    end
end
plt(1:T,data(:,:,1));
plt(1:T,data(:,:,2));
        