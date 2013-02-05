function testLineSearch
clc; close all;
global parameters
global test_u
test_u = [];
colls = descentCollection;
% parameters.globalDescentAlgorithm = colls.gdBackTrackingPos;
parameters.globalDescentAlgorithm = colls.ipOptPos;
% parameters.globalDescentAlgorithm = colls.gdBasicPos;
% parameters.globalDescentAlgorithm = colls.bfgsPos;

parameters.R = .01;
parameters.globalMaxIterations = 10;
parameters.alpha = .1;
% grad = @(x) 2*x;
% cost = @(x) x^2;
% 
% x_0 = 4;
% x_1 = -8;
% colls = descentCollection;
% 
% x_star = gradientDescent(x_0, cost, grad, 20, colls.backTrackingLineSearch, colls.stopIterating);
% x_star = gradientDescent(x_1, cost, grad, 20, colls.backTrackingLineSearch, colls.stopIterating);
% 
% assertVectorsAlmostEqual(0, x_star);
% 
% x_star = gradientDescent(x_1, cost, grad, 20, colls.backTrackingLineSearch, colls.stopIterating);
% 
% assertVectorsAlmostEqual(0, x_star);
% 

% scen = createScenario(10,30);
% scen = 
scen = io.loadScenario('../networks/2on2off.json');
% scen = io.loadScenario('../networks/samitha1onramp.json');
% u = [.9 .1; .9 .1;0 0;0 0;0 0;];
uoff = noControlU(scen);
os3 = forwardSimulation(scen, uoff);
% ustar = rampOptimalU(scen, uoff.*.5);
% os4 = forwardSimulation(scen, ustar);

ustar = uoff*.5;
for i = 1:5
  disp(['run ', num2str(i)]);
%   pause;
  ustar = rampOptimalU(scen, ustar);
  parameters.R = parameters.R*.1;
end
os4 = forwardSimulation(scen, ustar);
% rampOptimalU(scen, u);
% % u(1,2) = .2;
% % u(2,2) = 0;
% % rampOptimalU(scen, u);
% u(1,2) = .1;
% u(2,2) = .1;
% u(3,1) = .05;
% u(:,2:end) = 0
% plotting.plotBeforeAndAfter(scen, u);
% ustar = rampOptimalU(scen, u);
% os4 = forwardSimulation(scen, ustar);
sum(sum(os3.density)) + sum(sum(os3.queue))
sum(sum(os4.density)) + sum(sum(os4.queue))
totalTravelTime(scen, os3, uoff)
totalTravelTime(scen, os4, ustar)

plotting.spaceTimePlot(os3.density - os4.density, true);
plotting.spaceTimePlot(os3.queue - os4.queue, true);
plotting.plotForwardSim(scen, uoff);
plotting.plotForwardSim(scen, ustar);

end