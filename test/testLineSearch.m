function testLineSearch
clc;
global parameters
global test_u
test_u = [];
colls = descentCollection;
% parameters.globalDescentAlgorithm = colls.gdBackTrackingPos;
parameters.globalDescentAlgorithm = colls.gdBasicPos;
parameters.R = .005;
parameters.globalMaxIterations = 1000;
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

%scen = createScenario(10,30);
 scen = io.loadScenario('../networks/samitha1onramp.json');

% u = [.9 .1; .9 .1;0 0;0 0;0 0;];
u = noControlU(scen).*.5;
% rampOptimalU(scen, u);
% % u(1,2) = .2;
% % u(2,2) = 0;
% % rampOptimalU(scen, u);
% u(1,2) = .1;
% u(2,2) = .1;
% u(3,1) = .05;
% u(:,2:end) = 0
% plotting.plotBeforeAndAfter(scen, u);
ustar = rampOptimalU(scen, u);

end