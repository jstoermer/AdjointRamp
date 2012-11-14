function out = dhdx_h7a_fin_ip1_k(beta, fin, del, d, p)
if p * fin / ( 1- beta) > del
  out = 0;
elseif (1 - p) * fin > d
  out = -p;
else
  out = 0;
end
end