scen = loadScenario('networks/samitha1onramp.json');
T = scen.T; N = scen.N;
u = ones(T,N);
u(:,2) = .2;
plotBeforeAndAfter(scen,u);