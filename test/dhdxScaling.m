function [NTVaryX, dhdxVaryX] = dhdxScaling(varargin)
% PURPOSE:
% To calculate and plot the times for the dh_dx algorithm. It will scale
% with respect to the product N * T, where N is the number links and
% T is the number of time iterations.

% OUTPUTS:
% 1. NTVaryX: An array of products, N * T, with holding one variable
%    constant and varying the other variable, X.
% 2. dhdxVaryX: A matrix of the times for various functions in dh_dx. The
%    various functions are separated into the following rows:
%        1. dh_dx,
%        2. for loop iterations,
%        3. sparse matrix creation,
%        4. rhoConstraints,
%        5. lConstraints,
%        6. delConstraints,
%        7. sigConstraints,
%        8. dConstraints,
%        9. fInConstraints,
%       10. fOutConstraints, and
%       11. rConstraints.
% 3. A plot of the times for various functions in dh_dx against the scale of 
%    the scenario, where the the scale is determined by the product N * T.

% INPUTS:
% 1. minNT: The minimum product of N * T.
% 2. maxNT: The maximum product of N * T.
% 3. nTrials: The number of trials.
% 4. (Optional) varyNT: Vary N, T, or both.  Available options are 'N',
%    'T', or 'both'. Not specifying an argument will default to 'N'.
% 5. (Optional) nDistr: Distribution of trials. Available options are
%    'linear' and 'log'. Not specifying an argument will default to
%    'linear'.

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
    
    % Set the output variables.
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
    
    % Set the output variables.
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
    
    % Set the output variables.
    NTVaryX = NTVaryT;
    dhdxVaryX = dhdxVaryT;
    
end % if

end % testdhdx