function out = dh_dx(scen, states, u)
%% HACK HACK HACK
dt = scen.dt;
T = scen.T;
N = scen.N;
C = 8;
n = (T + 1)*N*C;
idxfn = @(a,b,c) idx(N, a, b, c);
cs = {'rho','l','del','sig','d','fin','fout','r'};
out = sparse(n,n);

for k = 1:T+1 % time step iterator
  for ci = 1:8
    c = cs{ci}; % variable type iterator
    if ci > 2 && k == T+1
      return;
    end
    for i = 1:N % cell iterator
      hi = idxfn(k,ci,i); % equation index (matches w/ variable type)
      if strcmp('rho',c)
        if k == 1 % if initial condition (no 0 time)
          xi = hi;
          out(hi,xi) = dhdx_i1_rho_i_0();
        else % TODO: need to check block
          xi = hi;
          out(hi,xi) = dhdx_h1a_rho_i_k();
          xi = idxfn(k-1,ci,i);
          out(hi,xi) = dhdx_h1a_rho_i_km1();
          xi = idxfn(k-1,'fout',i);
          out(hi,xi) = dhdx_h1a_fout_i_km1(dt,scen.links(i).L);
          xi = idxfn(k-1,'fin',i);
          out(hi,xi) = dhdx_h1a_fin_i_km1(dt,scen.links(i).L);
        end % end block
      end
      
      if strcmp('l',c)
        if k == 1 % if initial condition (no 0 time)
          xi = hi;
          out(hi,xi) = dhdx_i2_l_i_0();
        else
          xi = hi;
          out(hi,xi) = dhdx_h2_l_i_k();
          xi = idxfn(k-1,ci,i);
          out(hi,xi) = dhdx_h2_l_i_km1();
          xi = idxfn(k-1,'r',i);
          out(hi,xi) = dhdx_h2_r_i_k(dt);
        end
      end
      
      if strcmp('del',c)
        xi = hi;
        out(hi,xi) = dhdx_h3_del_i_k();
        xi = idxfn(k,'rho',i);
        rho = states.density(k,i);
        link = scen.links(i);
        v = link.v;
        F = link.fm;
        out(hi,xi) = dhdx_h3_rho_i_k(rho,v,F);
      end
      
      if strcmp('sig',c)
        xi = hi;
        out(hi,xi) = dhdx_h4_sig_i_k();
        xi = idxfn(k,'rho',i);
        rho = states.density(k,i);
        link = scen.links(i);
        w = link.w;
        rho_j = link.pm;
        F = link.fm;
        
        out(hi,xi) = dhdx_h4_rho_i_k(rho,w,rho_j,F);
        
      end
      
      if strcmp('d',c)
        xi = hi;
        out(hi,xi) = dhdx_h5_d_i_k();
        xi = idxfn(k,'l',i);
        l = states.queue(k,i);
        uVal = u(k,i);
        out(hi,xi) = dhdx_h5_l_i_k(l,uVal);
      end
      
      if strcmp('fin',c)
        
        if i == 1 % if first cell (no upstream mainline)
          xi = hi;
          out(hi,xi) = dhdx_h6b_fin_1_k();
          
          r = states.rampDemand(k,1);
          sig = states.supply(k,1);
          
          xi = idxfn(k,'r',1);
          out(hi,xi) = dhdx_h6b_r_1_k(r,sig);
          
          xi = idxfn(k,'sig',1);
          out(hi,xi) = dhdx_h6b_sig_1_k(r,sig);
        else
          xi = hi;
          out(hi,xi) = dhdx_h6a_fin_i_k();
          del = states.demand(k,i-1);
          sig = states.supply(k,i);
          beta = scen.BC.beta(k,i);
          d = states.rampDemand(k,i);
          xi = idxfn(k,'r',i);
          out(hi,xi) = dhdx_h6a_del_im1_k(del,beta,d,sig);
          
          xi = idxfn(k,'sig',i);
          out(hi,xi) = dhdx_h6a_sig_i_k(del,beta,d,sig);
          
          xi = idxfn(k,'d',i-1);
          out(hi,xi) = dhdx_h6a_d_im1_k(del,beta,d,sig);
        end
      end
      
      if strcmp('fout',c)
        if i == N % if end cell (no downstream cell)
          xi = hi;
          out(hi,xi) = dhdx_h7a_fout_i_k();
          xi = idxfn(k,'del',i);
          out(hi,xi) = dhdx_h7a_del_N_k();
        else % TODO: THIS NEEDS TO BE CHECKED
          xi = hi;
          out(hi,xi) = dhdx_h7a_fout_i_k();
          
          del = states.demand(k,i);
          fin = states.fluxIn(k,i+1);
          beta = scen.BC.beta(k,i+1);
          d = states.rampDemand(k,i+1);
          
          xi = idxfn(k,'del',i);
          out(hi,xi) = dhdx_h7a_del_i_k(beta,fin,del,d);
          
          xi = idxfn(k,'fin',i+1);
          out(hi,xi) = dhdx_h7a_fin_ip1_k(beta,fin,del,d);
          
          xi = idxfn(k,'d',i);
          out(hi,xi) = dhdx_h7a_d_i_k(beta,fin,del,d);
        end % END OF CHECK
      end
      
      
      if strcmp('r',c)
        if i == 1 % if first cell (no upstream cell)
          xi = hi;
          out(hi,xi) = dhdx_h8_r_i_k();
          xi = idxfn(k,'fin',i);
          out(hi,xi) = dhdx_h8_fin_1_k();
        else % TODO: THIS NEEDS TO BE CHECKED
          xi = hi;
          out(hi,xi) = dhdx_h8_r_i_k();
          beta = scen.BC.beta(k,i);
          xi = idxfn(k,'fin',i);
          out(hi,xi) = dhdx_h8_fin_ip1_k();
          xi = idxfn(k,'fout',i-1);
          out(hi,xi) = dhdx_h8_fout_i_k(beta);
        end % END OF CHECK
      end
    end
  end
end
end
