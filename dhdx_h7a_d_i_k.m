function out = dhdx_h7a_d_i_k(beta, fin, del, d, p)
if p * fin / ( 1- beta) > del
  out = 0;
elseif (1 - p) * fin > d
  out = 0;
else
  out = 1;
end
end