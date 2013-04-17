function samithaTestCase2

close all
global u12;

global parameters;
colls = descentCollection;
parameters.R =.1   ;
parameters.alpha = .15;
parameters.globalMaxIterations = 45;
% parameters.globalDescentAlgorithm = colls.gdBasicPos;
parameters.globalDescentAlgorithm = colls.ipOptPos;

u12 = [];
scen = io.loadScenario('../networks/samitha1onrampdt5.json');

uoff = noControlU(scen);
%figure(1)
ustar = rampOptimalU(scen, uoff)
os3 = forwardSimulation(scen, ustar);
sum(sum(os3.density)) + sum(sum(os3.queue))
os3.density
os3.queue
%HeatMap(os3.density);
%figure(2)
%HeatMap(os3.queue);
end