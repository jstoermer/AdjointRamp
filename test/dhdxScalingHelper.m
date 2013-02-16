function [NTVaryX, dhdxTocs] = dhdxScalingHelper(minNT, maxNT, nTrials, X, nDistr)

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
        
        dhdxTocs(1, i) = currAlgTocs{3}(1);
        dhdxTocs(2, i) = currAlgTocs{3}(2);
        dhdxTocs(3, i) = currAlgTocs{3}(3);
        dhdxTocs(4, i) = currAlgTocs{3}(4);
        dhdxTocs(5, i) = currAlgTocs{3}(5);
        dhdxTocs(6, i) = currAlgTocs{3}(6);
        dhdxTocs(7, i) = currAlgTocs{3}(7);
        dhdxTocs(8, i) = currAlgTocs{3}(8);
        dhdxTocs(9, i) = currAlgTocs{3}(9);
        dhdxTocs(10, i) = currAlgTocs{3}(10);
        dhdxTocs(11, i) = currAlgTocs{3}(11);
    end % for i
else
    error('Incorrect argument for X. X must be ''N'' or ''T''.');
end % if

end % testdhdhxHelper