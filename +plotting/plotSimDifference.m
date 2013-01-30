function plotSimDifference(state_1, state_2)

numTimeSteps = size(state_1.density, 1);

density_1 = state_1.density;
queue_1 = state_1.queue;
uPenalty_1 = [state_1.uPenalty; zeros(1, size(state_1.uPenalty, 2))];

density_2 = state_2.density;
queue_2 = state_2.queue;
uPenalty_2 = [state_2.uPenalty; zeros(1, size(state_2.uPenalty, 2))];

% Does not work as intended.
% plotting.spaceTimePlot(density_2 - density_1, true);
% plotting.spaceTimePlot(queue_2 - queue_1, true);
sumDensity_1 = sum(density_1,2);
sumDensity_2 = sum(density_2,2);

sumQueue_1 = sum(queue_1, 2);
sumQueue_2 = sum(queue_2, 2);

sumUPenalty_1 = sum(uPenalty_1, 2);
sumUPenalty_2 = sum(uPenalty_2, 2);

totalState_1 = sumDensity_1 + sumQueue_1 + sumUPenalty_1;
totalState_2 = sumDensity_2 + sumQueue_2 + sumUPenalty_2;

figure;

subplot(2,1,1);
h = area(cumsum([sumDensity_1'; sumQueue_1'; sumUPenalty_1'], 2)');
set(h(1), 'FaceColor', [0.5 0 0])
set(h(2), 'FaceColor', [0.7 0 0])
set(h(3), 'FaceColor', [0.9 0 0])
alpha(0.4);
hold on;

h = area(cumsum([sumDensity_2'; sumQueue_2'; sumUPenalty_2'], 2)','LineWidth', 2,'LineStyle','--');
set(h(1),'FaceColor',[0 0.5 0])
set(h(2),'FaceColor',[0 0.7 0])
set(h(3),'FaceColor',[0 0.9 0])
alpha(0.4);

xTickLabel = {};
for i = 0:(numTimeSteps - 1)
   xTickLabel{i + 1} = num2str(i); 
end

xTick = 1:numTimeSteps;

xlabel('Time Step');
ylabel('Cumulative Density');
title('Comparative Density');
legend('Previous Main', 'Previous Ramp', 'Previous \it{u}\rm Penalty', 'Optimal Main', 'Optimal Ramp', 'Optimal \it{u}\rm Penalty');
set(gca, 'XTick', xTick, 'XTickLabel', xTickLabel);

subplot(2,1,2);
grid on;
hold on;
plot(cumsum(sumDensity_2 - sumDensity_1),'b-.', 'LineWidth', 2);
plot(cumsum(sumQueue_2 - sumQueue_1),'r:', 'LineWidth', 2);
plot(cumsum(sumUPenalty_2 - sumUPenalty_1), 'g-','LineWidth', 2);
plot(cumsum(totalState_2 - totalState_1),'k', 'LineWidth', 3);
legend('Density Difference', 'Ramp Difference', '\it{u}\rm Penalty Difference', 'Total Difference');
xlabel('Time Step');
ylabel('Cumulative Density');
title('Cumulative Density Difference');
set(gca, 'XTick', xTick, 'XTickLabel', xTickLabel);

end % end plotSimDifference