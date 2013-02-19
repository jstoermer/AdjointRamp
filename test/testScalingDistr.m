function X = testScalingDistr(minNT, maxNT, nTrials, nDistr)
% PURPOSE:
% Helper function to testScaling. Creates an array, X, of the specified
% distribution, nDistr.

% OUTPUTS:
% X: An array of the specified distrubtion, nDistr, between minNT and maxNT.

% INPUTS:
% 1. minNT: The minimum product of N * T.
% 2. maxNT: The maximum product of N * T.
% 3. nTrials: The number of trials.
% 4. nDistr: Distribution of trials. Available options are 'linear' and 
%    'log'.

if strcmp(nDistr, 'linear')
    X = linspace(1, maxNT/minNT, nTrials);
    X = round(X);
elseif strcmp(nDistr, 'log')
    X = logspace(0, log10(maxNT/minNT), nTrials);
    X = round(X);
else
    error('Incorrect argument for nDistr. nDistr must be ''linear'' or ''log''.');
end % if

end % testScalingDistr