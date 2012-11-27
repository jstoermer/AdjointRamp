function plotSimDifference(s1, s2)

rho1 = s1.density;
l1 = s1.queue;

rho2 = s2.density;
l2 = s2.queue;

plotting.spaceTimePlot(rho2 - rho1, true);
plotting.spaceTimePlot(l2 - l1, true);
sumr1 = sum(rho1,2);
sumr2 = sum(rho2,2);
suml1 = sum(l1,2);
suml2 = sum(l2,2);
tot1 = sumr1 + suml1;
tot2 = sumr2 + suml2;
figure
h = area(cumsum([sumr1';suml1'],2)');
set(h(1),'FaceColor',[.5 0 0])
set(h(2),'FaceColor',[.7 0 0])
alpha(.4);
hold on
h = area(cumsum([sumr2';suml2'],2)','LineWidth',2,'LineStyle','--');
set(h(1),'FaceColor',[0 .5 0])
set(h(2),'FaceColor',[0 .7 0])
xlabel('Time');
ylabel('Cumulative Density');
title('Comparative Density');
alpha(.4);
legend('prev main', 'prev ramp', 'opt main', 'opt ramp');
figure;
grid on;
hold on;
plot(cumsum(sumr2 - sumr1),'b-.','LineWidth',2);
plot(cumsum(suml2 - suml1),'r:','LineWidth', 2);
plot(cumsum(tot2 - tot1),'k', 'LineWidth', 3);
legend('density diff', 'ramp diff', 'tot diff');
xlabel('Time');
ylabel('Cum. Density');
title('Cum .Density Difference');
end