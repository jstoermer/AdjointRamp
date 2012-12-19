function [] = sweepR(varargin);

% The last argument will always be the number of trials. Trials correspond
% to the following values for R: 0.01, 0.1, 1, 10, 100, ...

numTrials = varargin{end};
varargin(end) = [];

[myScenario, u] = scenUVarArgIn(varargin);



end % end sweepR