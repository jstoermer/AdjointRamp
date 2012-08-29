function out = dh_dx(scen, states)
dt = scen.dt; dx = scen.dx;
T = length(states) - 1;
N = length(states(1).densities) - 1;
n =  T * (8 * N - 1);
idx = @(a,b,c) idx_lookup(a,b,c,N);

cs = {'rho','l','del','sig','d','fin','fout','r'};
cstart = [0,1,0,1,1,1,0,1];
cend = [N,N-1,N,N,N-1,N,N-1,N-1];
out = sparse(n,n);

for ci = 1:8
    c = cs{ci};
    i_s = cstart(ci);
    i_e = cend(ci);
    for k = 0:T-1
        for i = i_s:i_e
            hi = idx(k,c,i);
            if strcmp('rho',c)
                if k == 0
                    xi = hi;
                    out(hi,xi) = dhdx_i1_rho_i_0();
                elseif i == 0
                    xi = hi;
                    out(hi,xi) = dhdx_h1b_rho_0_k();
                    xi = idx(k-1,c,i);
                    out(hi,xi) = dhdx_h1b_rho_0_km1();
                    xi = idx(k-1,'fout',i);
                    out(hi,xi) = dhdx_h1b_fout_0_km1(dt,dx);
                elseif i == N
                    xi = hi;
                    out(hi,xi) = dhdx_h1c_rho_N_k();
                    xi = idx(k-1,c,i);
                    out(hi,xi) = dhdx_h1c_rho_N_km1();
                    xi = idx(k-1,'fout',i);
                    out(hi,xi) = dhdx_h1c_fout_N_km1(dt,dx);
                    xi = idx(k,'del',i);
                    out(hi,xi) = dhdx_h1c_del_N_k(dt,dx); 
                else
                    xi = hi;
                    out(hi,xi) = dhdx_h1a_rho_i_k();
                    xi = idx(k-1,c,i);
                    out(hi,xi) = dhdx_h1a_rho_i_km1();
                    xi = idx(k-1,'fout',i);
                    out(hi,xi) = dhdx_h1a_fout_i_km1(dt,dx);
                    xi = idx(k-1,'fin',i);
                    out(hi,xi) = dhdx_h1a_fin_i_km1(dt,dx); 
                end
            end
            
            if strcmp('l',c)
                if k == 0
                    xi = hi;
                    out(hi,xi) = dhdx_i2_l_i_0();                    
                else
                    xi = hi;
                    out(hi,xi) = dhdx_h2_l_i_k();
                    xi = idx(k-1,c,i);
                    out(hi,xi) = dhdx_h2_l_i_km1();
                    xi = idx(k,'r',i);
                    out(hi,xi) = dhdx_h2_r_i_k(dt);
                end
            end
            
            if strcmp('del',c)
                xi = hi;
                out(hi,xi) = dhdx_h3_del_i_k();
                xi = idx(k,'rho',i);
                
                rho = states(k+1).densities(i+1);
                if i == 0
                    cell = scen.dummy;
                else
                    cell = scen.cells(i);
                end
                v = cell.fd.v;
                F = cell.fd.f_max;
                
                out(hi,xi) = dhdx_h3_rho_i_k(rho,v,F);
                
            end
            
            if strcmp('sig',c)
                xi = hi;
                out(hi,xi) = dhdx_h4_sig_i_k();
                xi = idx(k,'rho',i);
                
                rho = states(k+1).densities(i+1);
                w = scen.cells(i).fd.w;
                rho_j = scen.cells(i).fd.rho_j;
                F = scen.cells(i).fd.f_max;
                
                out(hi,xi) = dhdx_h4_rho_i_k(rho,w,rho_j,F);
                
            end
            
            if strcmp('d',c)
                xi = hi;
                out(hi,xi) = dhdx_h5_d_i_k();
                xi = idx(k,'l',i);
                l = states(k+1).ramp_queues(i);
                u = scen.u(k+1,i);
                out(hi,xi) = dhdx_h5_l_i_k(l,u);
            end
            
            if strcmp('fin',c)
                
                if i == 1
                    xi = hi;
                    out(hi,xi) = dhdx_h6b_fin_1_k();
                    
                    del = states(k+2).demands(1);
                    sig = states(k+2).supplies(1);
                    
                    xi = idx(k,'del',0);
                    out(hi,xi) = dhdx_h6b_del_0_k(del,sig);
                    
                    xi = idx(k,'sig',1);
                    out(hi,xi) = dhdx_h6b_sig_1_k(del,sig);
                else
                    xi = hi;
                    out(hi,xi) = dhdx_h6a_fin_i_k();

                    del = states(k+2).demands(i);
                    sig = states(k+2).supplies(i);
                    beta = scen.beta(k+1,i-1);
                    d = states(k+2).ramp_demands(i-1);                    
                    
                    xi = idx(k,'del',i-1);
                    out(hi,xi) = dhdx_h6a_del_im1_k(del,beta,d,sig);
                    
                    xi = idx(k,'sig',i);
                    out(hi,xi) = dhdx_h6a_sig_i_k(del,beta,d,sig);
                    
                    xi = idx(k,'d',i-1);
                    out(hi,xi) = dhdx_h6a_d_im1_k(del,beta,d,sig);
                end                    
            end
            
            if strcmp('fout',c)
                
                if i == 0
                    xi = hi;
                    out(hi,xi) = dhdx_h7b_fout_0_k();

                    xi = idx(k,'fin',1);
                    out(hi,xi) = dhdx_h7b_fin_1_k();
                else
                    xi = hi;
                    out(hi,xi) = dhdx_h7a_fout_i_k();

                    del = states(k+2).demands(i);
                    fin = states(k+2).flow_ins(i);
                    beta = scen.beta(k+1,i);
                    d = states(k+2).ramp_demands(i);
                    
                    
                    xi = idx(k,'del',i);
                    out(hi,xi) = dhdx_h7a_del_i_k(beta,fin,del,d);
                    
                    xi = idx(k,'fin',i+1);
                    out(hi,xi) = dhdx_h7a_fin_ip1_k(beta,fin,del,d);
                    
                    xi = idx(k,'d',i);
                    out(hi,xi) = dhdx_h7a_d_i_k(beta,fin,del,d);
                end                    
            end
            
            
            if strcmp('r',c)
                xi = hi;
                out(hi,xi) = dhdx_h8_r_i_k();

                beta = scen.beta(k+1,i);
                
                xi = idx(k,'fin',i+1);
                out(hi,xi) = dhdx_h8_fin_ip1_k();
                
                xi = idx(k,'fout',i);
                out(hi,xi) = dhdx_h8_fout_i_k(beta);
            end
        end
    end
end
end