function out = idx_lookup(k,c,i,N)
n_rho = N + 1;
n_l = N - 1;
n_del = N + 1;
n_sig = N;
n_d = N - 1;
n_f_in = N;
n_f_out = N;
n_r = N - 1;

k_val = k * (8 * N - 1);

if strcmp(c,'rho')
    offset = 1;
    c_val = 0;
elseif strcmp(c,'l')
    offset = 0;
    c_val = n_rho;
elseif strcmp(c,'del')
    offset = 1;
    c_val = n_rho + n_l;
elseif strcmp(c,'sig')
    offset = 0;
    c_val = n_rho + n_l+ n_del;
elseif strcmp(c,'d')
    offset = 0;
    c_val = n_rho + n_l+ n_del + n_sig;
elseif strcmp(c,'fin')
    offset = 0;
    c_val = n_rho + n_l+ n_del + n_sig + n_d;
elseif strcmp(c,'fout')
    offset = 1;
    c_val = n_rho + n_l+ n_del + n_sig + n_d + n_f_in;
elseif strcmp(c,'r')
    offset = 0;
    c_val = n_rho + n_l+ n_del + n_sig + n_d + n_f_in + n_f_out;
end

i_val = i;

out = k_val + c_val + i_val + offset;

end
