function [NTVaryX, timeVaryX] = testScalingVary(minNT, maxNT, nTrials, X, nDistr)
% PURPOSE:
% Helper function to testScaling. Calculates the times of the optimization
% algorithms.

% OUTPUTS:
% 1. NTVaryX: An array of products, N * T, with holding one variable
%    constant and varying the other variable, X.
% 2. timeVaryX: An array of the times of the optimizations for varying
%    products, N * T. Corresponds to the array, NTVaryX.

% INPUTS:
% 1. minNT: The minimum product of N * T.
% 2. maxNT: The maximum product of N * T.
% 3. nTrials: The number of trials.
% 4. X: Vary N, T, or both.  Available options are 'N', 'T', or 'both'.
% 5. nDistr: Distribution of trials. Available options are 'linear' and 
%    'log'.

NTVaryX = zeros(1, nTrials);
timeVaryX = zeros(1, nTrials);

if strcmp(X, 'N')
    N = testScalingDistr(minNT, maxNT, nTrials, nDistr);
    T = minNT;
    for i = 1:nTrials
        currNT = N(i) * T;
        NTVaryX(i) = currNT;
        currScen = createScenario(N(i), T);
        u = noControlU(currScen);
        adjStruct = rampAdjointStructures(currScen);
        tic;
        adjStruct.structure.objective(u);
        adjStruct.structure.gradient(u);
        currTime = toc;
        timeVaryX(i) = currTime;
    end % for i
elseif strcmp(X, 'T')
    N = minNT;
    T = testScalingDistr(minNT, maxNT, nTrials, nDistr);
    for i = 1:nTrials
        currNT = N * T(i);
        NTVaryX(i) = currNT;
        currScen = createScenario(N, T(i));
        u = noControlU(currScen);
        adjStruct = rampAdjointStructures(currScen);
        tic;
        adjStruct.structure.objective(u);
        adjStruct.structure.gradient(u);
        currTime = toc;
        timeVaryX(i) = currTime;
    end % for i
else
    error('Incorrect argument for X. X must be "N" or "T".');
end % if

end % testScalingVary