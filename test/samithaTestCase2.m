function samithaTestCase2

close all
global u12;

global parameters;
colls = descentCollection;
parameters.R =.01   ;
parameters.alpha = .1
parameters.globalMaxIterations = 400;
parameters.globalDescentAlgorithm = colls.gdBasicPos;

u12 = [];
scen = io.loadScenario('../networks/samitha1onramp.json');

uoff = noControlU(scen);
%figure(1)
ustar = rampOptimalU(scen, uoff);
os3 = forwardSimulation(scen, ustar);
sum(sum(os3.density)) + sum(sum(os3.queue))
os3.density
os3.queue
%HeatMap(os3.density);
%figure(2)
%HeatMap(os3.queue);
end