function out = dhdx_h4_rho_i_k(rho,w,rho_j,F)
if w*(rho_j - rho) < F
    out = w;
else
    out = 0;
end
end