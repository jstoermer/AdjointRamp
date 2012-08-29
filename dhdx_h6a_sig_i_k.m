function out = dhdx_h6a_sig_i_k(del,beta,d,sig)
if (del) * (1 - beta) + d >= sig
    out = -1;
else
    out = 0;
end
end