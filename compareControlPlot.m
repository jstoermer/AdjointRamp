function compareControlPlot(scen,u0)

u_uc = ones(size(u0)).*1000;
u_c = adjointBFGS(scen, u0);
scen_uc = scen;
scen_c = scen;

scen_uc.u = u_uc;
scen_c.u = u_c;
scen_uc = forward_sim(scen_uc);
scen_c = forward_sim(scen_c);

plotCompareScenarios(scen_uc, scen_c);



end