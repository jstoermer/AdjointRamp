function out = dhdx_h6b_sig_1_k(del,sig)
if (del) >= sig
    out = -1;
else
    out = 0;
end
end