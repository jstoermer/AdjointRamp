% PURPOSE: 
% Loads sampleScen. Plots link densities and queue lengths for before and 
% after optimization for 5 iterations. Iterations vary the number of time
% steps: 25, 50, 75, 100, 125.

load('sampleScen/sampleScen.mat');
dummyScen = sampleScen;
for i = 1:5
    plotting.plotBeforeAndAfter(dummyScen);
    dummyScen = extendScenario(dummyScen, 25);
end % end for