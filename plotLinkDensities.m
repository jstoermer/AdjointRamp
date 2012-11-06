function plotLinkDensities(scen)
close all; clc;
data = datafy_states(scen.states);
densities = data(:,:,1)';

% createfigure(densities);

figure1 = figure;
xlabels = {};
for i = 0:scen.N+1
    xlabels{i+1} = ['Link ' num2str(i)];
end
ylabels = {};
for i = 0:scen.T+1
    ylabels{i+1} = num2str(i);
end
xticks = .5:scen.N + 1.5;
yticks = .5:1:(scen.T + 1.5);
axes1 = axes('Parent', figure1, 'XTickLabel',xlabels,'XTick',xticks,'YTickLabel',ylabels,'YTick',yticks,'Layer','top');
xlim(axes1,[.5,scen.N + 1.5]);
ylim(axes1,[.5, scen.T + 1.5]);
box(axes1,'on');
hold(axes1,'all');
image(densities,'Parent',axes1,'CDataMapping','scaled');
xlabel('Downstream');
ylabel('Time');
title('Density Profile');
colorbar;
end