function out = scen_with_time_range(main_scen, k_start, k_end_hor, rho0, l0)

beta = main_scen.beta(k_start+1:k_end_hor+1,:);
D0 = main_scen.D0(k_start+1:k_end_hor+1);
D = main_scen.D(k_start+1:k_end_hor+1,:);
cells = main_scen.cells;
dt = main_scen.dt; dx = main_scen.dx;
R = main_scen.R;

out = scenario(rho0,l0,D0,D,cells,beta,dt, dx);
out.R = R;
end