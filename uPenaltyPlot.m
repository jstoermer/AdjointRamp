function [] = uPenaltyPlot(uPenalty)

[T, N] = size(uPenalty);

myFigure = figure;

xlabels = {};
for i = 0:(N + 1)
    xlabels{i + 1} = ['Link ' num2str(i)]; 
end % end for loop

ylabels = {};
for i = 0:(T + 1)
    ylabels{i + 1} = num2str(i);
end % end for loop

xticks = 0.5 : (N + 1.5);
yticks = 0.5 : (T + 1.5);

myAxes = axes('Parent', myFigure, 'XTickLabel',xlabels,'XTick',xticks,'YTickLabel',ylabels,'YTick',yticks,'Layer','top');
xlim(myAxes,[0.5, N + 0.5]);
ylim(myAxes,[0.5, T + 0.5]);
box(myAxes,'on');
hold(myAxes,'all');
image(uPenalty,'Parent',myAxes,'CDataMapping','scaled');
xlabel('Downstream');
ylabel('Time');
title('Penalty To U');
colorbar;
    
end % end plotUPenalty