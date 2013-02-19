function [NTVaryX, dhdxVaryX] = dhdxScaling(varargin)

minNT = varargin{1};
maxNT = varargin{2};
nTrials = varargin{3};
varargin(1:3) = [];

varyNT = 'N'; % Default option for varyNT.
nDistr = 'linear'; % Default option for nDistr.

if length(varargin) == 1
    if length(varargin{1}) == 1 || length(varargin{1}) == 4
        varyNT = varargin{1};
    else
        nDistr = varargin{1};
    end % if
elseif length(varargin) == 2
    varyNT = varargin{1};
    nDistr = varargin{2};
end % if

if strcmp(varyNT, 'both')
    
    nTrials = ceil(nTrials/2);
    [NTVaryN, dhdxVaryN] = dhdxScalingHelper(minNT, maxNT, nTrials, ...
        'N', nDistr);
    [NTVaryT, dhdxVaryT] = dhdxScalingHelper(minNT, maxNT, nTrials, ...
        'T', nDistr);
    
    % Plot the running times for the overall function, before the for
    % loops, and after the for loops.
    plot(NTVaryN, dhdxVaryN(1:3, :)', '-', NTVaryT, dhdxVaryT(1:3, :)', ...
        '-.');
    
    % Plot the running times for individual functions.
    figure();
    ColorSet = hsv(8);
    set(gca, 'ColorOrder', ColorSet);
    hold all;
    plot(NTVaryN, dhdxVaryN(4:11, :)', '-', NTVaryT, ...
        dhdxVaryT(4:11, :)', '-.');
    hold off;
    
    NTVaryX = [NTVaryN, NTVaryT];
    dhdxVaryX = [dhdxVaryN, dhdxVaryT];
    
elseif strcmp(varyNT, 'N')
    
    [NTVaryN, dhdxVaryN] = dhdxScalingHelper(minNT, maxNT, nTrials, ...
        'N', nDistr);
    
    % Plot the running times for the overall function, before the for
    % loops, and after the for loops.
    plot(NTVaryN, dhdxVaryN(1:3, :)');
    title('dhdx Running Time Vs. Scale (N {\times} T)');
    xlabel('Scale (N {\times} T)');
    ylabel('Running Time (Seconds)');
    legend('Total Running Time', 'For Loops Running Time', ...
        'Sparse Matrix Creation Running Time', 'Location', 'Northwest');
    
    % Plot the running times for individual functions.
    figure();
    ColorSet = hsv(10);
    set(gca, 'ColorOrder', ColorSet);
    hold all;
    plot(NTVaryN, dhdxVaryN(4:11, :)');
    title('Individual dhdx Function Running Times Vs. Scale (N {\times} T)');
    xlabel('Scale (N {\times} T)');
    ylabel('Running Time (Seconds)');
    legend('rhoConstraints', 'lConstraints', 'delConstraints', ...
        'sigConstraints', 'dConstraints', 'fInConstraints', ...
        'fOutConstraints', 'rConstraints', 'Location', 'Northwest');
    hold off;
    
    NTVaryX = NTVaryN;
    dhdxVaryX = dhdxVaryN;
    
elseif strcmp(varyNT, 'T')
    
    [NTVaryT, dhdxVaryT] = dhdxScalingHelper(minNT, maxNT, nTrials, ...
        'T', nDistr);
    plot(NTVaryT, dhdxVaryT, 'o-.');
    
    % Plot the running times for the overall function, before the for
    % loops, and after the for loops.
    plot(NTVaryT, dhdxVaryT(1:3, :)');
    
    % Plot the running times for individual functions.
    figure();
    ColorSet = hsv(8);
    set(gca, 'ColorOrder', ColorSet);
    hold all;
    plot(NTVaryT, dhdxVaryT(4:11, :)');
    hold off;
    
    NTVaryX = NTVaryT;
    dhdxVaryX = dhdxVaryT;
    
end % if

end % testdhdx