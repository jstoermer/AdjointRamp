function out = scenario(rho_0,l_0,D0, D,cells,beta, dt, dx)
out.rho_0 = rho_0;
out.dt = dt;
out.dx = dx;
out.beta = beta;
out.l_0 = l_0;
out.D = D;
out.cells = cells;
out.D0 = D0;
out.N = size(D, 2) + 1;
out.T = size(D,1);

% YOU NEED TO ADD u TO STRUCT IN ORDER FOR STUFF TO WORK



end
