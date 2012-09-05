function plotCompareScenarios(scen_uc,scen_c)
uc_data = datafy_states(scen_uc.states);
c_data = datafy_states(scen_c.states);

uc_rho = uc_data(:,:,1);
uc_l = uc_data(:,:,2);
c_rho = c_data(:,:,1);
c_l = c_data(:,:,2);

T = scen_uc.T;
N = scen_uc.N;

plt(1:T+1,[uc_rho;c_rho]);
plt(1:T+1,[uc_l;c_l]);

end