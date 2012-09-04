function compareControlPlot(scen,u0)

u_uc = ones(size(u0)).*1000;
u_c = adjointBFGS(scen, u0);
scen_uc = scen;
scen_c = scen;

scen_uc.u = u_uc;
scen_c.u = u_c;
scen_uc = forward_sim(scen_uc);
scen_c = forward_sim(scen_c);

uc_data = datafy_states(scen_uc.states);
c_data = datafy_states(scen_c.states);

uc_rho = uc_data(:,:,1);
uc_l = uc_data(:,:,2);
c_rho = c_data(:,:,1);
c_l = c_data(:,:,2);

T = scen.T;
N = scen.N;

plt(1:T+1,[uc_rho;c_rho]);
plt(1:T+1,[uc_l;c_l]);



end