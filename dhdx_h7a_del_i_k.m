function out = dhdx_h7a_del_i_k(beta, fin, del, d, p)
if p * fin / ( 1- beta) > del
  out = -(1 - beta);
elseif (1 - p) * fin > d
  out = 0;
else
  out = 0;
end
end