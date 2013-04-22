function testLineSearch
clc; close all;
tic;
do_plot = false;
global parameters
global test_u
test_u = [];
colls = descentCollection;
% parameters.globalDescentAlgorithm = colls.gdBackTrackingPos;
% parameters.globalDescentAlgorithm = colls.ipOptPos;
% parameters.globalDescentAlgorithm = colls.gdBasicPos;
% parameters.globalDescentAlgorithm = colls.bfgsPos;
parameters.globalDescentAlgorithm = colls.fMinCon;
% parameters.globalDescentAlgorithm = colls.knitroOptPos;


parameters.R = 0.1;
parameters.globalMaxIterations = 100;
parameters.alpha = 0.5;

% scen = io.loadScenario('../networks/2on2off.json');
% scen = io.loadScenario('../networks/samitha1onramp.json');
% scen = io.convertBeatsToScenario('../networks/smalltest.xml');
% scen = io.convertBeatsToScenario('../networks/smallTestVary.xml');
% scen = io.convertBeatsToScenario('../networks/smallExample.xml');
% scen = io.convertBeatsToScenario('../networks/tinyExample2.xml');
scen = evalin('base', 'NT_10');

% new test for debugging
% u = [.9 .1; .9 .1;0 0;0 0;0 0;];
uoff = noControlU(scen);
os3 = forwardSimulation(scen, uoff);
% ustar = rampOptimalU(scen, uoff * 0.5);
% os4 = forwardSimulation(scen, ustar);
ustar = uoff * 0.5;
iters =  5;
stepScaling = 0.1;
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

% sum(sum(os3.density)) + sum(sum(os3.queue))
% sum(sum(os4.density)) + sum(sum(os4.queue))
% totalTravelTime(scen, os3, uoff)
% totalTravelTime(scen, os4, ustar)

runningTime = toc;

%clc;
disp('Total travel time for scenario with no control = ');
disp(findTTT(scen, os3));
disp('Total travel time for scenario with control = ');
disp(findTTT(scen, os4));
disp('Total objective cost for scenario with no control = ');
disp(findObjective(scen, os3, uoff));
disp('Total objective cost for scenario with control = ');
disp(findObjective(scen, os4, ustar));
disp(['Total running time for testLineSearch was ', num2str(runningTime), ' seconds.']);

% The following plots the "activity" of u for tinyExample.xml.
% uActivity_os3_onramp1 = onRampActivity(os3, 1, uoff);
% uActivity_os3_onramp2 = onRampActivity(os3, 5, uoff);
% uActivity_os4_onramp1 = onRampActivity(os4, 1, ustar);
% uActivity_os4_onramp2 = onRampActivity(os4, 5, ustar);
% T = 1:length(uActivity_os3_onramp1);
% plot(T, uActivity_os3_onramp1, T, uActivity_os3_onramp2, T, uActivity_os4_onramp1, T, uActivity_os4_onramp2);
% legend('u_{off} for On-Ramp #1', 'u_{off} for On-Ramp #2', 'u_* for On-Ramp #1', 'u_* for On-Ramp #2');
% ylabel('Arbitrary Unit for u "Activity"');
% xlabel('Time Step');

if do_plot
  plotting.spaceTimePlot(os3.density - os4.density, true);
  plotting.spaceTimePlot(os3.queue - os4.queue, true);
  plotting.plotForwardSim(scen, uoff);
  plotting.plotForwardSim(scen, ustar);
end % end if

end % end testLineSearch