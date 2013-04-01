function extScen = extendScenario(currScen, numTimeSteps)
% Extends currScen by appending numTimeSteps time steps.

extScen = currScen;
extScen.T = currScen.T + numTimeSteps;
extScen.nConstraints = (extScen.T + 1) * extScen.N * 8;
extScen.nControls = extScen.T * extScen.N;
extScen.BC.D = [currScen.BC.D; zeros(numTimeSteps, size(currScen.BC.D, 2))];
extScen.BC.beta = [currScen.BC.beta; repmat(currScen.BC.beta(end, :), numTimeSteps, 1)];

end % end extendScenario