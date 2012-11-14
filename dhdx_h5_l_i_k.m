function out = dhdx_h5_l_i_k(l,u, rmax, dt);
if l / dt < u && l / dt < rmax
    out = -1 / dt;
else
    out = 0;
end
end