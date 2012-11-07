function spaceTimePlot(varargin)
densities = varargin{1};
if nargin == 2
    whitezero = varargin{2};
else
    whitezero = false;
end
[T,N] = size(densities);

% createfigure(densities);

figure1 = figure;
xlabels = {};
for i = 0:N+1
    xlabels{i+1} = ['Link ' num2str(i)];
end
ylabels = {};
for i = 0:T+1
    ylabels{i+1} = num2str(i);
end
xticks = .5:N + 1.5;
yticks = .5:1:(T + 1.5);
axes1 = axes('Parent', figure1, 'XTickLabel',xlabels,'XTick',xticks,'YTickLabel',ylabels,'YTick',yticks,'Layer','top');
xlim(axes1,[.5,N + 1.5]);
ylim(axes1,[.5, T + 1.5]);
box(axes1,'on');
hold(axes1,'all');
image(densities,'Parent',axes1,'CDataMapping','scaled');
xlabel('Downstream');
ylabel('Time');
title('Density Profile');
colorbar;
if whitezero
    bottom = min(min(densities));
    top = max(max(densities));
    colormap(b2r(bottom, top));
end