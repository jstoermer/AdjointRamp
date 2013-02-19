function algTocs = testAlgorithms(testScen)
% PURPOSE:
% Helper function to testScaling. Calculates the times for various
% algorithms for a given scenario, testScen.

% OUTPUTS:
% algToc: A cell array containing the times for various algorithms, in the
% following order:
%   1. loadScenario
%   2. updateStates
%   3. dhdx
%   4. dhdu, beforeToc, afterToc. beforeToc is the time before the embedded
%      for loop and afterToc is the time after the embedded for loop.
%   5. djdx
%   6. djdu
%   7. solveSystem

% INPUTS:
% testScen: A scenario, which can be created from createScenario.

u = noControlU(testScen);
adjStructs = rampAdjointStructures(testScen);
adjStruct = adjStructs.structure;

tic;
io.loadScenario(testScen);
loadScenToc = toc;

tic;
scenStates = adjStruct.updateStates(u);
updateToc = toc;

t = tic;
[dhdx, dhdxTocs] = adjStruct.partials.dhdx(testScen, scenStates, u);
dhdxToc = toc(t);

tic;
dhdu = adjStruct.partials.dhdu(testScen, scenStates, u);
dhduToc = toc;

tic;
djdx = adjStruct.partials.djdx(testScen, scenStates, u);
djdxToc = toc;

tic;
djdu = adjStruct.partials.djdu(testScen, scenStates, u);
djduToc = toc;

tic;
adjStruct.solveSystem(dhdx, djdx, djdu, dhdu);
solveToc = toc;

algTocs = {loadScenToc, updateToc, [dhdxToc, dhdxTocs], ...
    dhduToc, djdxToc, djduToc, solveToc};

end % testAlgorithms