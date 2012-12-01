function spaceTimePlot(varargin)

% Creates a default struct that contains the plotting parameters.
plotInfo = struct('xLabel', '', 'yLabel', '', 'title', '', 'axesHandle', '', 'whiteZero', false);

primaryArg = varargin{1};

if nargin == 2;
    otherArg = varargin{2};
    
    % If the additional argument is a double, it corresponds to the
    % whitezero value.
    if islogical(otherArg)
        if otherArg == 1
            plotInfo.whiteZero = true;
        end % end if
        
        % If the additional argument is a struct, it corresponds to a struct
        % that may contain plotting parameters.
    elseif isstruct(otherArg)
        
        if isfield(otherArg, 'xLabel')
            plotInfo.xLabel = otherArg.xLabel;
        elseif isfield(otherArg, 'yLabel')
            plotInfo.yLabel = otherArg.yLabel;
        elseif isfield(otherArg, 'title')
            plotInfo.title = otherArg.title;
        elseif isfield(otherArg, 'axesHandle')
            plotInfo.axesHandle = otherArg.axesHandle;
        elseif isfield(otherArg, 'whiteZero')
            plotInfo.whiteZero = otherArg.whiteZero;
        end % end if
        
    else
        error('Incorrect variable type for additional argument.');
    end % end if
    
else
    error('Incorrect number of arguments.');
end

[T,N] = size(primaryArg);

% createfigure(primaryArg);

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
xlim(axes1,[.5, N + .5]);
ylim(axes1,[.5, T + .5]);
box(axes1,'on');
hold(axes1,'all');
image(primaryArg,'Parent',axes1,'CDataMapping','scaled');
xlabel(plotInfo.xLabel);
ylabel(plotInfo.yLabel);
title(plotInfo.title);
colorbar;

if plotInfo.whiteZero
    bottom = min(min(primaryArg));
    top = max(max(primaryArg));
    colormap(b2r(bottom, top));
end

end