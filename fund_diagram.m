function out = fund_diagram(v,w,f_max)

rho_c = f_max / v;
int = f_max + w * rho_c;
rho_j = w * int;

out.v = v;
out.w = w;
out.f_max = f_max;
out.rho_c = rho_c;
out.rho_j = rho_j;

end