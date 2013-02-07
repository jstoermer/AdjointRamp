function algTocs = testAlgorithms(testScen)
% PURPOSE:
% Helper function to testScaling. Calculates the times for various
% algorithms for a given scenario, testScen.

% OUTPUTS:
% algToc: An array containing the times for various algorithms, in the
% following order:
%   1. loadScenario
%   2. updateStates
%   3. dhdx
%   4. dhdu
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

tic;
dhdx = adjStruct.partials.dhdx(testScen, scenStates, u);
dhdxToc = toc;

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

algTocs = [loadScenToc; updateToc; dhdxToc; dhduToc; djdxToc; djduToc; ...
    solveToc];

end % testAlgorithms