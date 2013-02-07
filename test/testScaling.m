function [] = testScaling(varargin)
% PURPOSE:
% To calculate and plot the times for the optimization algorithms. It will
% scale with respect to the product N * T, where N is the number links and
% T is the number of time iterations.

% OUTPUTS:
% A plot of the times for the optimization algorithms against the scale of
% the scenario, where the the scale is determined by the product N * T.

% INPUTS:
% 1. minNT: The minimum product of N * T.
% 2. maxNT: The maximum product of N * T.
% 3. nTrials: The number of trials.
% 4. (Optional) varyNT: Vary N, T, or both.  Available options are 'N',
%    'T', or 'both'. Not specifying an argument will default to 'both'.
% 5. (Optional) nDistr: Distribution of trials. Available options are
%    'linear' and 'log'. Not specifying an argument will default to
%    'linear'.

minNT = varargin{1};
maxNT = varargin{2};
nTrials = varargin{3};
varargin(1:3) = [];

varyNT = 'both'; % Default option for varyNT.
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
    [NTVaryN, timeVaryN] = testScalingVary(minNT, maxNT, nTrials, 'N', nDistr);
    [NTVaryT, timeVaryT] = testScalingVary(minNT, maxNT, nTrials, 'T', nDistr);
    fitVaryN = polyfit(NTVaryN, timeVaryN, 2);
    fitVaryT = polyfit(NTVaryT, timeVaryT, 2);
    rangeVaryN = min(NTVaryN):max(NTVaryN);
    rangeVaryT = min(NTVaryT):max(NTVaryT);
    plot(NTVaryN, timeVaryN, 'bo', rangeVaryN, polyval(fitVaryN, ...
        rangeVaryN), 'b-', NTVaryT, timeVaryT, 'ro', rangeVaryT, ...
        polyval(fitVaryT, rangeVaryT), 'r-');
    legVaryN = ['N = [1, ..., ', num2str(maxNT/minNT), '], T = ', num2str(minNT)];
    legVaryT = ['N = ', num2str(minNT), ', T = [1, ..., ', num2str(maxNT/minNT), ']'];
    legend(legVaryN, 'Quadratic Fit To Varying N', legVaryT, 'Quadratic Fit To Varying T');
elseif strcmp(varyNT, 'N')
    [NTVaryN, timeVaryN] = testScalingVary(minNT, maxNT, nTrials, 'N', nDistr);
    plot(NTVaryN, timeVaryN, 'bo');
    fitVaryN = polyfit(NTVaryN, timeVaryN, 2);
    rangeVaryN = min(NTVaryN):max(NTVaryN);
    plot(NTVaryN, timeVaryN, 'bo', rangeVaryN, polyval(fitVaryN, ...
        rangeVaryN), 'b-');
    legVaryN = ['N = [1, ..., ', num2str(maxNT/minNT), '], T = ', num2str(minNT)];
    legend(legVaryN, 'Quadratic Fit To Varying N');
elseif strcmp(varyNT, 'T')
    [NTVaryT, timeVaryT] = testScalingVary(minNT, maxNT, nTrials, 'T', nDistr);
    fitVaryT = polyfit(NTVaryT, timeVaryT, 2);
    rangeVaryT = min(NTVaryT):max(NTVaryT);
    plot(NTVaryT, timeVaryT, 'ro', rangeVaryT, polyval(fitVaryT, ...
        rangeVaryT), 'r-');
    legVaryT = ['N = ', num2str(minNT), ', T = [1, ..., ', num2str(maxNT/minNT), ']'];
    legend(legVaryT, 'Quadratic Fit To Varying T');
end % if

xlabel('N {\times} T');
ylabel('Algorithm Time (s)');
title('Algorithm Time Vs. N {\times} T');

end % testScaling