function X = testScalingDistr(minNT, maxNT, nTrials, nDistr)

if strcmp(nDistr, 'linear')
    X = linspace(1, maxNT/minNT, nTrials);
    X = ceil(X);
elseif strcmp(nDistr, 'log')
    X = logspace(0, log10(maxNT/minNT), nTrials);
    X = ceil(X);
else
    error('Incorrect argument for nDistr. nDistr must be "linear" or "log".');
end % if

end % testScalingDistr