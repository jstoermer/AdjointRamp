function [NTVaryX, algTocs] = testScalingVary(minNT, maxNT, nTrials, X, nDistr)
% PURPOSE:
% Helper function to testScaling. Calculates the times of various
% algorithms against the scale of the scenario, i.e. N * T.

% OUTPUTS:
% 1. NTVaryX: An array of products, N * T, with holding one variable
%    constant and varying the other variable, X.
% 2. algTocs: A matrix of the times for various algorithms. The various
%    algorithms are separated into the following rows:
%       1. loadScenario
%       2. updateStates
%       3. dhdx
%       4. dhdu
%       5. djdx
%       6. djdu
%       7. solveSystem

% INPUTS:
% 1. minNT: The minimum product of N * T.
% 2. maxNT: The maximum product of N * T.
% 3. nTrials: The number of trials.
% 4. X: Vary N or T.  Available options are 'N' or 'T'.
% 5. nDistr: Distribution of trials. Available options are 'linear' and
%    'log'.

NTVaryX = zeros(1, nTrials);
loadScenTocs = zeros(1, nTrials);
updateTocs = zeros(1, nTrials);
dhdxTocs = zeros(1, nTrials);
dhduTocs = zeros(1, nTrials);
djdxTocs = zeros(1, nTrials);
djduTocs = zeros(1, nTrials);
solveTocs = zeros(1, nTrials);

if strcmp(X, 'N')
    N = testScalingDistr(minNT, maxNT, nTrials, nDistr);
    T = minNT;
    for i = 1:nTrials
        currNT = N(i) * T;
        disp(['Current trial is ', num2str(i), ' of ', ...
            num2str(nTrials), ', where N = ', num2str(N(i)), ', T = ', ...
            num2str(T), ', and N * T = ', num2str(currNT), '.']);
        NTVaryX(i) = currNT;
        currScen = createScenario(N(i), T);
        currAlgTocs = testAlgorithms(currScen);
        loadScenTocs(i) = currAlgTocs{1};
        updateTocs(i) = currAlgTocs{2};
        dhdxTocs(i) = currAlgTocs{3}(1);
        dhduTocs(i) = currAlgTocs{4};
        djdxTocs(i) = currAlgTocs{5};
        djduTocs(i) = currAlgTocs{6};
        solveTocs(i) = currAlgTocs{7};
    end % for i
elseif strcmp(X, 'T')
    N = minNT;
    T = testScalingDistr(minNT, maxNT, nTrials, nDistr);
    for i = 1:nTrials
        currNT = N * T(i);
        disp(['Current trial is ', num2str(i), ' of ', ...
            num2str(nTrials), ', where N = ', num2str(N), ', T = ', ...
            num2str(T(i)), ', and N * T = ', num2str(currNT), '.']);
        NTVaryX(i) = currNT;
        currScen = createScenario(N, T(i));
        currAlgTocs = testAlgorithms(currScen);
        loadScenTocs(i) = currAlgTocs{1};
        updateTocs(i) = currAlgTocs{2};
        dhdxTocs(i) = currAlgTocs{3}(1);
        dhduTocs(i) = currAlgTocs{4};
        djdxTocs(i) = currAlgTocs{5};
        djduTocs(i) = currAlgTocs{6};
        solveTocs(i) = currAlgTocs{7};
    end % for i
else
    error('Incorrect argument for X. X must be ''N'' or ''T''.');
end % if

algTocs = [loadScenTocs; updateTocs; dhdxTocs; dhduTocs; djdxTocs; ...
    dhduTocs; solveTocs];

end % testScalingVary