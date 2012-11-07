function plotSimDifference(s1,s2)
s1 = forward_sim(s1);
data = datafy_states(s1.states);
rho1 = data(:,:,1)';
s2 = forward_sim(s2);
data = datafy_states(s2.states);
rho2 = data(:,:,1)';
spaceTimePlot(rho2 - rho1);
sum1 = sum(rho1,1);
sum2 = sum(rho2,1);
figure
plot(sum1,'b')
hold on
plot(sum2, 'r')
legend(['Previous', 'Optimal']);
end