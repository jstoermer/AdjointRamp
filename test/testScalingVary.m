function varargout = testScalingVary(minNT, maxNT, nTrials, X, nDistr)
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
% 3. indivDhdxTocs: A matrix of the times for the algorithm, dhdx.
%    Separates the individual times for each step.

% INPUTS:
% 1. minNT: The minimum product of N * T.
% 2. maxNT: The maximum product of N * T.
% 3. nTrials: The number of trials.
% 4. X: Vary N, T, or both.  Available options are 'N', 'T', or 'both'.
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
indivDhdxTocs = zeros(8, nTrials);

if strcmp(X, 'N')
    N = testScalingDistr(minNT, maxNT, nTrials, nDistr);
    T = minNT;
    for i = 1:nTrials
        currNT = N(i) * T;
        NTVaryX(i) = currNT;
        currScen = createScenario(N(i), T);
        currAlgTocs = testAlgorithms(currScen);
        loadScenTocs(i) = currAlgTocs{1};
        updateTocs(i) = currAlgTocs{2};
        dhdxTocs(i) = currAlgTocs{3}(1);
        indivDhdxTocs(1, i) = currAlgTocs{3}(2);
        indivDhdxTocs(2, i) = currAlgTocs{3}(3);
        indivDhdxTocs(3, i) = currAlgTocs{3}(4);
        indivDhdxTocs(4, i) = currAlgTocs{3}(5);
        indivDhdxTocs(5, i) = currAlgTocs{3}(6);
        indivDhdxTocs(6, i) = currAlgTocs{3}(7);
        indivDhdxTocs(7, i) = currAlgTocs{3}(8);
        indivDhdxTocs(8, i) = currAlgTocs{3}(9);
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
        NTVaryX(i) = currNT;
        currScen = createScenario(N, T(i));
        currAlgTocs = testAlgorithms(currScen);
        loadScenTocs(i) = currAlgTocs{1};
        updateTocs(i) = currAlgTocs{2};
        dhdxTocs(i) = currAlgTocs{3}(1);
        indivDhdxTocs(1, i) = currAlgTocs{3}(2);
        indivDhdxTocs(2, i) = currAlgTocs{3}(3);
        indivDhdxTocs(3, i) = currAlgTocs{3}(4);
        indivDhdxTocs(4, i) = currAlgTocs{3}(5);
        indivDhdxTocs(5, i) = currAlgTocs{3}(6);
        indivDhdxTocs(6, i) = currAlgTocs{3}(7);
        indivDhdxTocs(7, i) = currAlgTocs{3}(8);
        indivDhdxTocs(8, i) = currAlgTocs{3}(9);
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

varargout{1} = NTVaryX;
varargout{2} = algTocs;
varargout{3} = indivDhdxTocs;

end % testScalingVary