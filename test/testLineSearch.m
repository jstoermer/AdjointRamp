function testLineSearch
clc; close all;
do_plot = true;
global parameters
global test_u
test_u = [];
colls = descentCollection;
% parameters.globalDescentAlgorithm = colls.gdBackTrackingPos;
% parameters.globalDescentAlgorithm = colls.ipOptPos;
parameters.globalDescentAlgorithm = colls.gdBasicPos;
% parameters.globalDescentAlgorithm = colls.bfgsPos;

parameters.R = 0.1;
parameters.globalMaxIterations = 100;
parameters.alpha = 0.1;
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
% scen = io.loadScenario('../networks/2on2off.json');
% scen = io.loadScenario('../networks/samitha1onramp.json');
% scen = io.convertBeatsToScenario('../networks/smalltest.xml');
% scen = io.convertBeatsToScenario('../networks/smallTestVary.xml');
% scen = io.convertBeatsToScenario('../networks/smallExample.xml');
scen = io.convertBeatsToScenario('../networks/tinyExample.xml');
% u = [.9 .1; .9 .1;0 0;0 0;0 0;];
uoff = noControlU(scen);
os3 = forwardSimulation(scen, uoff);
% ustar = rampOptimalU(scen, uoff.*.5);
% os4 = forwardSimulation(scen, ustar);

ustar = uoff * 0.5;
iters =  1;
stepScaling = 0.2;
ustar = rampOptimalUvarR(iters, stepScaling, scen, ustar);
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

% The following plots the "activity" of u for tinyExample.xml.
uActivity_os3_onramp1 = max(min(os3.queue(:, 1), scen.links(1).rmax) - [0; uoff(:, 1)], 0);
uActivity_os3_onramp2 = max(min(os3.queue(:, 5), scen.links(5).rmax) - [0; uoff(:, 5)], 0);
uActivity_os4_onramp1 = max(min(os4.queue(:, 1), scen.links(1).rmax) - [0; ustar(:, 1)], 0);
uActivity_os4_onramp2 = max(min(os4.queue(:, 5), scen.links(5).rmax) - [0; ustar(:, 5)], 0);
T = 1:length(uActivity_os3_onramp1);
plot(T, uActivity_os3_onramp1, T, uActivity_os3_onramp2, T, uActivity_os4_onramp1, T, uActivity_os4_onramp2);
legend('u_{off} for On-Ramp #1', 'u_{off} for On-Ramp #2', 'u_* for On-Ramp #1', 'u_* for On-Ramp #2');
ylabel('Arbitrary Unit for u "Activity"');
xlabel('Time Step');

if do_plot
  plotting.spaceTimePlot(os3.density - os4.density, true);
  plotting.spaceTimePlot(os3.queue - os4.queue, true);
  plotting.plotForwardSim(scen, uoff);
  plotting.plotForwardSim(scen, ustar);
end
end