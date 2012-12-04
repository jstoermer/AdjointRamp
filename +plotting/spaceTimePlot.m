function spaceTimePlot(varargin)

% Creates a default struct that contains the plotting parameters.
plotInfo = struct('xLabel', '', 'yLabel', '', 'title', '', 'axesHandle', '', 'whiteZero', false);

if nargin == 1
    primaryArg = varargin{1};

% If there are two arguments, the additional argument has to be a double or
% a struct.
elseif nargin == 2;
    primaryArg = varargin{1};
    otherArg = varargin{2};
    
    % If the additional argument is a double, it corresponds to the
    % whitezero value.
    if islogical(otherArg)
        
        if otherArg == 1
            plotInfo.whiteZero = true;
        end % end if block
        
    % If the additional argument is a struct, it corresponds to a struct
    % that may contain plotting parameters.
    elseif isstruct(otherArg)
        
        if isfield(otherArg, 'xLabel')
            plotInfo.xLabel = otherArg.xLabel;
        end
        
        if isfield(otherArg, 'yLabel')
            plotInfo.yLabel = otherArg.yLabel;
        end
        
        if isfield(otherArg, 'title')
            plotInfo.title = otherArg.title;
        end
        
        if isfield(otherArg, 'axesHandle')
            plotInfo.axesHandle = otherArg.axesHandle;
        end
        
        if isfield(otherArg, 'whiteZero')
            plotInfo.whiteZero = otherArg.whiteZero;
        end
    
    % If the additional argument is not a double or a struct, it is an
    % invalid argument.
    else
        error('Invalid argument. Additional argument must be a logical or a struct.');
    
    end % end iflogical(otherArg)

% If there are more than two arguments, there are an invalid number of
% arguments.
else
    error('Invalid number of arguments. Must have one or two arguments.');

end % end if nargin == 1

[T,N] = size(primaryArg);

xTickLabel = {};
for i = 0:(N + 1)
    xTickLabel{i + 1} = ['Link ' num2str(i)];
end

yTickLabel = {};
for i = 0:T+1
    yTickLabel{i + 1} = num2str(i);
end

xTick = 0.5:(N + 1.5);
yTick = 0.5:1:(T + 1.5);

if isempty(plotInfo.axesHandle)
    myFigure = figure();
    myAxes = axes('Parent', myFigure, 'XTickLabel',xTickLabel,'XTick',xTick,'YTickLabel',yTickLabel,'YTick',yTick,'Layer','top');
else
    myAxes = plotInfo.axesHandle;
    set(myAxes, 'Layer', 'top');
    set(myAxes, 'XTick', xTick);
    set(myAxes, 'YTickLabel', xTickLabel);
    set(myAxes, 'YTick', yTick);
    set(myAxes, 'YTickLabel', yTickLabel);
end
    
    
xlim(myAxes,[0.5, N + 0.5]);
ylim(myAxes,[0.5, T + 0.5]);
box(myAxes,'on');
hold(myAxes,'all');
image(primaryArg,'Parent',myAxes,'CDataMapping','scaled');
xlabel(plotInfo.xLabel);
ylabel(plotInfo.yLabel);
title(plotInfo.title);
colorbar;

if plotInfo.whiteZero
    try
        bottom = min(min(primaryArg));
        top = max(max(primaryArg));
        colormap(plotting.b2r(bottom, top));
    end
end

end