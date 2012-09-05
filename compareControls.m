function compareControls(scen, u1, u2)
scen1 = scen;
scen2 = scen;
scen1 = forward_sim(scen1,u1);
scen2 = forward_sim(scen2, u2);

plotCompareScenarios(scen1, scen2);

end