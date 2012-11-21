function out = dhdx_h1a_fin_i_km1(dt,dx)
out = -dt/dx;
end
function out = dhdx_h1a_fout_i_km1(dt,dx)
out = dt/dx;
end
function out = dhdx_h1a_rho_i_k()
out = 1;
end
function out = dhdx_h1a_rho_i_km1()
out = -1;
end
function out = dhdx_h1b_fout_0_km1(dt,dx)
out = dt/dx;
end
function out = dhdx_h1b_rho_0_k()
out = 1;
end
function out = dhdx_h1b_rho_0_km1()
out = -1;
end
function out = dhdx_h1c_del_N_k(dt,dx)
out = dt/dx;
end
function out = dhdx_h1c_fout_N_km1(dt,dx)
out = -dt/dx;
end
function out = dhdx_h1c_rho_N_k()
out = 1;
end
function out = dhdx_h1c_rho_N_km1()
out = -1;
end
function out = dhdx_h2_l_i_k()
out = 1;
end
function out = dhdx_h2_l_i_km1()
out = -1;
end
function out = dhdx_h2_r_i_k(dt)
out = dt;
end
function out = dhdx_h3_del_i_k()
out = 1;
end
function out = dhdx_h3_rho_i_k(rho,v,F)
if v * rho < F
    out = -v;
else
    out = 0;
end
end
function out = dhdx_h4_rho_i_k(rho,w,rho_j,F)
if w*(rho_j - rho) < F
    out = w;
else
    out = 0;
end
end
function out = dhdx_h4_sig_i_k()
out = 1;
end
function out = dhdx_h5_d_i_k()
out = 1;
end
function out = dhdx_h5_l_i_k(l,u, rmax, dt);
if l / dt < u && l / dt < rmax
    out = -1 / dt;
else
    out = 0;
end
end
function out = dhdx_h6a_d_im1_k(del,beta,d,sig)
if (del) * (1 - beta) + d < sig
    out = -1;
else
    out = 0;
end
end
function out = dhdx_h6a_del_im1_k(del,beta,d,sig)
if (del) * (1 - beta) + d < sig
    out = -(1 - beta);
else
    out = 0;
end
end
function out = dhdx_h6a_fin_i_k()
out = 1;
end
function out = dhdx_h6a_sig_i_k(del,beta,d,sig)
if (del) * (1 - beta) + d >= sig
    out = -1;
else
    out = 0;
end
end
function out = dhdx_h6b_d_1_k(d,sig)
if (d) < sig
    out = -1;
else
    out = 0;
end
end
function out = dhdx_h6b_del_0_k(del,sig)
if (del) < sig
    out = -1;
else
    out = 0;
end
end
function out = dhdx_h6b_fin_1_k()
out = 1;
end
function out = dhdx_h6b_sig_1_k(d,sig)
if (d) >= sig
    out = -1;
else
    out = 0;
end
end
function out = dhdx_h7a_d_i_k(beta, fin, del, d, p)
if p * fin / ( 1- beta) > del
  out = 0;
elseif (1 - p) * fin > d
  out = 0;
else
  out = 1;
end
end
function out = dhdx_h7a_del_i_k(beta, fin, del, d, p)
if p * fin / ( 1- beta) > del
  out = -(1 - beta);
elseif (1 - p) * fin > d
  out = 0;
else
  out = 0;
end
end
function out = dhdx_h7a_del_N_k()
out = -1;
end
function out = dhdx_h7a_fin_ip1_k(beta, fin, del, d, p)
if p * fin / ( 1- beta) > del
  out = 0;
elseif (1 - p) * fin > d
  out = -p;
else
  out = 0;
end
end
function out = dhdx_h7a_fout_i_k()
out = 1;
end
function out = dhdx_h7b_fin_1_k()
out = -1;
end
function out = dhdx_h7b_fout_0_k()
out = 1;
end
function out = dhdx_h8_fin_1_k()
out = -1;
end
function out = dhdx_h8_fin_ip1_k()
out = -1;
end
function out = dhdx_h8_fout_i_k(beta)
out = (1 - beta);
end
function out = dhdx_h8_r_i_k()
out = 1;
end
function out = dhdx_i1_rho_i_0()
out = 1;
end
function out = dhdx_i2_l_i_0()
out = 1;
end