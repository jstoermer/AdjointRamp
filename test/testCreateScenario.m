N = 10;
T = 20;

scen = createScenario(N,T);

no_u = noControlU(scen);
u_1 = no_u.*.5;

disp(totalTravelTime(scen, no_u));
% disp(totalTravelTime(scen, rampOptimalU(scen, u_1)));

plotting.plotNoControlVsOptimal(scen, u_1);