function [NTVaryX, dhdxTocs] = dhdxScalingHelper(minNT, maxNT, nTrials, X, nDistr)
% PURPOSE:
% Helper function to dhdxScaling. Calculates the times of various
% functions in dh_dx against the scale of the scenario, i.e. N * T.

% OUTPUTS:
% 1. NTVaryX: An array of products, N * T, with holding one variable
%    constant and varying the other variable, X.
% 2. dhdxTocs: A matrix of the times for various functions in dh_dx. The
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

% INPUTS:
% 1. minNT: The minimum product of N * T.
% 2. maxNT: The maximum product of N * T.
% 3. nTrials: The number of trials.
% 4. X: Vary N, T, or both.  Available options are 'N' or 'T'.
% 5. nDistr: Distribution of trials. Available options are 'linear' and
%    'log'.

NTVaryX = zeros(1, nTrials);
dhdxTocs = zeros(9, nTrials);

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
        
        % Complete dhdx function.
        dhdxTocs(1, i) = currAlgTocs{3}(1);
        % For loops.
        dhdxTocs(2, i) = currAlgTocs{3}(2);
        % Sparse matrix creation.
        dhdxTocs(3, i) = currAlgTocs{3}(3);
        % rhoConstraints function.
        dhdxTocs(4, i) = currAlgTocs{3}(4);
        % lConstraints function.
        dhdxTocs(5, i) = currAlgTocs{3}(5);
        % delConstraints function.
        dhdxTocs(6, i) = currAlgTocs{3}(6);
        % sigConstraints function.
        dhdxTocs(7, i) = currAlgTocs{3}(7);
        % dConstraints function.
        dhdxTocs(8, i) = currAlgTocs{3}(8);
        % fInConstraints function.
        dhdxTocs(9, i) = currAlgTocs{3}(9);
        % fOutConstraints function.
        dhdxTocs(10, i) = currAlgTocs{3}(10);
        % rConstraints function.
        dhdxTocs(11, i) = currAlgTocs{3}(11);
    end % for i
    
elseif strcmp(X, 'T')
    N = minNT;
    T = testScalingDistr(minNT, maxNT, nTrials, nDistr);
    for i = 1:nTrials
        currNT = N * T(i);
        NTVaryX(i) = currNT;
        currScen = createScenario(N, T(i));
        currAlgTocs = testAlgorithms(currScen);
        
        disp(['Current trial is ', num2str(i), ' of ', ...
            num2str(nTrials), ', where N = ', num2str(N), ', T = ', ...
            num2str(T(i)), ', and N * T = ', num2str(currNT), '.']);
        
        % Complete dhdx function.
        dhdxTocs(1, i) = currAlgTocs{3}(1);
        % For loops.
        dhdxTocs(2, i) = currAlgTocs{3}(2);
        % Sparse matrix creation.
        dhdxTocs(3, i) = currAlgTocs{3}(3);
        % rhoConstraints function.
        dhdxTocs(4, i) = currAlgTocs{3}(4);
        % lConstraints function.
        dhdxTocs(5, i) = currAlgTocs{3}(5);
        % delConstraints function.
        dhdxTocs(6, i) = currAlgTocs{3}(6);
        % sigConstraints function.
        dhdxTocs(7, i) = currAlgTocs{3}(7);
        % dConstraints function.
        dhdxTocs(8, i) = currAlgTocs{3}(8);
        % fInConstraints function.
        dhdxTocs(9, i) = currAlgTocs{3}(9);
        % fOutConstraints function.
        dhdxTocs(10, i) = currAlgTocs{3}(10);
        % rConstraints function.
        dhdxTocs(11, i) = currAlgTocs{3}(11);
    end % for i
    
else
    error('Incorrect argument for X. X must be ''N'' or ''T''.');
end % if

end % testdhdhxHelper