function [] = testScaling(varargin)
% PURPOSE:
% To calculate and plot the times for various algorithms. It will scale
% with respect to the product N * T, where N is the number links and
% T is the number of time iterations.

% ADDED:
% - Prompt the user to plot the times before and after the for loop in the
%   algorithm, dhdx. (Added 2/7).

% OUTPUTS:
% A plot of the times for various algorithms against the scale of the
% scenario, where the the scale is determined by the product N * T.

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

plotdhdx = input('Do you want to plot the times before and after the for loop for dhdx? ', 's');

if strcmp(varyNT, 'both')
    nTrials = ceil(nTrials/2);
    [NTVaryN, tocsVaryN, dhdxVaryN] = testScalingVary(minNT, maxNT, nTrials, 'N', nDistr);
    [NTVaryT, tocsVaryT, dhdxVaryT] = testScalingVary(minNT, maxNT, nTrials, 'N', nDistr);
    plot(NTVaryN, tocsVaryN', 'o-', NTVaryT, tocsVaryT', 'o-.');
    legend('loadScenario, Varying N', 'updateStates, Varying N', 'dhdx, Varying N', ...
        'dhdu, Varying N', 'djdx, Varying N', 'djdu, Varying N', 'solveSystem, Varying N', ...
        'loadScenario, Varying T', 'updateStates, Varying T', 'dhdx, Varying T', ...
        'dhdu, Varying T', 'djdx, Varying T', 'djdu, Varying T', 'solveSystem, Varying T', ...
        'Location', 'Northwest');
    xlabel('N {\times} T, Varying Both N And T');
    ylabel('Algorithm Time (s)');
    title('Algorithm Time Vs. N {\times} T, Varying Both N And T');
    if strcmp(plotdhdx, 'y')
        figure();
        plot(NTVaryN, dhdxVaryN', 'o-', NTVaryT, dhdxVaryT', 'o-.');
%         legend('Before For Looop, Varying N', 'After For Loop, Varying N', ...
%             'Before For Loop, Varying T', 'After For Loop, Varying T', ...
%             'Location', 'Northwest');
        xlabel('N {\times} T, Varying Both N And T');
        ylabel('Algorithm Time (s)');
        title('dhdx Algorithm Time Vs. N {\times} T, Varying Both N And T');
    end % if
elseif strcmp(varyNT, 'N')
    [NTVaryN, tocsVaryN, dhdxVaryN] = testScalingVary(minNT, maxNT, nTrials, 'N', nDistr);
    plot(NTVaryN, tocsVaryN', 'o-');
    legend('loadScenario', 'updateStates', 'dhdx', 'dhdu', 'djdx', 'djdu', ...
        'solveSystem', 'Location', 'Northwest');
    xlabel('N {\times} T, Varying N');
    ylabel('Algorithm Time (s)');
    title('Algorithm Time Vs. N {\times} T, Varying N');
    if strcmp(plotdhdx, 'y')
        figure();
        plot(NTVaryN, dhdxVaryN', 'o-');
        legend('rhoConstraints', 'lConstraints', 'delConstraints', 'sigConstraints', 'dConstraints', 'fInConstraints', 'fOutConstraints', 'rConstraints', 'Location', 'Northwest');
        xlabel('N {\times} T, Varying N');
        ylabel('Algorithm Time (s)');
        title('dhdx Algorithm Time Vs. N {\times} T, Varying N');
    end % if
elseif strcmp(varyNT, 'T')
    [NTVaryT, tocsVaryT, dhdxVaryT] = testScalingVary(minNT, maxNT, nTrials, 'N', nDistr);
    plot(NTVaryT, tocsVaryT', 'o-.');
%     legend('loadScenario', 'updateStates', 'dhdx', 'dhdu', 'djdx', 'djdu', ...
%         'solveSystem', 'Location', 'Northwest');
    xlabel('N {\times} T, Varying T');
    ylabel('Algorithm Time (s)');
    title('Algorithm Time Vs. N {\times} T, Varying T');
    if strcmp(plotdhdx, 'y')
        figure();
        plot(NTVaryT, dhdxVaryT', 'o-.');
        legend('Before For Looop, Varying T', 'After For Loop, Varying T', ...
            'Location', 'Northwest');
        xlabel('N {\times} T, Varying T');
        ylabel('Algorithm Time (s)');
        title('dhdx Algorithm Time Vs. N {\times} T, Varying T');
    end % if
end % if

end % testScaling