function out = dhdx_h3_rho_i_k(rho,v,F)
if v * rho < F
    out = -v;
else
    out = 0;
end
end