function [scen1 scen2] = compareControls(scen, u1, u2)
scen1 = scen;
scen1.u = u1;
scen2 = scen;
scen2.u = u2;
scen1 = forward_sim(scen1);
scen2 = forward_sim(scen2);

plotCompareScenarios(scen1, scen2);

end