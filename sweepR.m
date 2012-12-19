function [] = sweepR(scenFile, numTrials)

% The last argument will always be the number of trials. Trials correspond
% to the following values for R: 0.01, 0.1, 1, 10, 100, ...

scen = io.loadScenario(scenFile);

t = zeros(1, numTrials);
r = zeros(1, numTrials);

global parameters;

for i = 1:numTrials
    parameters.R = 10^(i-3);
    r(i) = parameters.R;
    tic;
    rampOptimalU(scen);
    t(i) = toc;
end % end for i = 1:numTrials

plot(r, t);
title('Algorithm Time vs. R-Value');
xlabel('R-Value');
ylabel('Algorithm Time (Seconds)');

end % end sweepR