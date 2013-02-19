close all;

NTVaryN = [];
NTVaryT = [];
perfVaryN = [];
perfVaryT = [];

N = 100;
for i = 1:10
    T = 10*i;
    NT = N*T;
    NTVaryT = [NTVaryT, NT];
    currScen = createScenario(N, T);
    u = noControlU(currScen);
    adjStruct = rampAdjointStructures(currScen);
    tic;
    adjStruct.structure.objective(u);
    adjStruct.structure.gradient(u);
    currPerf = toc;
    perfVaryT = [perfVaryT, currPerf];
end % for i

T = 100;
for i = 1:10
    T = 10*i;
    NT = N*T;
    NTVaryN = [NTVaryN, NT];
    currScen = createScenario(N, T);
    u = noControlU(currScen);
    adjStruct = rampAdjointStructures(currScen);
    tic;
    adjStruct.structure.objective(u);
    adjStruct.structure.gradient(u);
    currPerf = toc;
    perfVaryN = [perfVaryN, currPerf];
end % for i

% Fit a quadratic to the set of data.
fitVaryT = polyfit(NTVaryT, perfVaryT, 2);
fitVaryN = polyfit(NTVaryN, perfVaryN, 2);

rangeVaryT = min(NTVaryT):max(NTVaryT);
rangeVaryN = min(NTVaryN):max(NTVaryN);

plot(NTVaryT, perfVaryT, 'bo', rangeVaryT, polyval(fitVaryT, ...
    rangeVaryT), 'b-', NTVaryN, perfVaryN, 'ro', rangeVaryN, ...
    polyval(fitVaryN, rangeVaryN), 'r-');
xlabel('N {\times} T');
ylabel('Algorithm Time (s)');
title('Algorithm Time Vs. N {\times} T');
legend('N = 100, T = 10, 20, ..., 100', 'Quadratic Fit To Varying T', ...
    'T = 100, N = 10, 20, ..., 100', 'Quadratic Fit To Varying N');