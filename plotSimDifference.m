function plotSimDifference(s1,s2)
s1 = forward_sim(s1);
data = datafy_states(s1.states);
rho1 = data(:,:,1)';
l1 = data(:,:,2)';
s2 = forward_sim(s2);
data = datafy_states(s2.states);
rho2 = data(:,:,1)';
l2 = data(:,:,2)';
spaceTimePlot(rho2 - rho1, true);
sumr1 = sum(rho1,1);
sumr2 = sum(rho2,1);
suml1 = sum(l1,1);
suml2 = sum(l2,1);
figure
h = area(cumsum([sumr1;suml1],2)');
set(h(1),'FaceColor',[.5 0 0])
set(h(2),'FaceColor',[.7 0 0])
alpha(.4);
hold on
h = area(cumsum([sumr2;suml2],2)','LineWidth',2,'LineStyle','--');
set(h(1),'FaceColor',[0 .5 0])
set(h(2),'FaceColor',[0 .7 0])
xlabel('Time');
ylabel('Cumulative Density');
title('Comparative Density');
alpha(.4);
legend('prev main', 'prev ramp', 'opt main', 'opt ramp');
figure;
h = area(cumsum([sumr2;suml2],2)'-cumsum([sumr1;suml1],2)');
set(h(1),'FaceColor',[1.0 0.0 0])
set(h(2),'FaceColor',[0 1.0 0])
alpha(.4);
legend('density diff', 'ramp diff');
xlabel('Time');
ylabel('Cumulative Density');
title('Cumulative Density Difference');
end