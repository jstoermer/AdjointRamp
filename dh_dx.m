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
  kk = min(k,T); % necessary iterator for T+1 flux boundary conditions
  for ci = 1:8
    c = cs{ci}; % variable type iterator
    for i = 1:N % cell iterator
      hi = idxfn(k,ci,i); % equation index (matches w/ variable type)
      switch c
        case 'rho'; rhoConstraints();
        case 'l'; lConstraints();
        case 'del'; delConstraints();
        case 'sig'; sigConstraints();
        case 'd'; dConstraints();
        case 'fin'; fInConstraints();
        case 'fout'; fOutConstraints();
        case 'r'; rConstraints();
      end
    end
  end
end

  function rhoConstraints()
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


  function lConstraints()
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


  function delConstraints()
    xi = hi;
    out(hi,xi) = dhdx_h3_del_i_k();
    xi = idxfn(k,'rho',i);
    rho = states.density(k,i);
    link = scen.links(i);
    v = link.v;
    F = link.fm;
    out(hi,xi) = dhdx_h3_rho_i_k(rho,v,F);
    
  end


  function sigConstraints()
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

  function dConstraints()
    xi = hi;
    out(hi,xi) = dhdx_h5_d_i_k();
    xi = idxfn(k,'l',i);
    l = states.queue(k,i);
    uVal = u(kk,i);
    out(hi,xi) = dhdx_h5_l_i_k(l,uVal);
    
  end

  function fInConstraints()
    if i == 1 % if first cell (no upstream mainline)
      xi = hi;
      out(hi,xi) = dhdx_h6b_fin_1_k();
      
      d = states.rampDemand(kk,1);
      sig = states.supply(kk,1);
      
      xi = idxfn(k,'d',1);
      out(hi,xi) = dhdx_h6b_d_1_k(d,sig);
      
      xi = idxfn(k,'sig',1);
      out(hi,xi) = dhdx_h6b_sig_1_k(d,sig);
    else
      xi = hi;
      out(hi,xi) = dhdx_h6a_fin_i_k();
      del = states.demand(kk,i-1);
      sig = states.supply(kk,i);
      beta = scen.BC.beta(kk,i);
      d = states.rampDemand(kk,i);
      xi = idxfn(k,'del',i);
      out(hi,xi) = dhdx_h6a_del_im1_k(del,beta,d,sig);
      
      xi = idxfn(k,'sig',i);
      out(hi,xi) = dhdx_h6a_sig_i_k(del,beta,d,sig);
      
      xi = idxfn(k,'d',i-1);
      out(hi,xi) = dhdx_h6a_d_im1_k(del,beta,d,sig);
    end
    
  end

  function fOutConstraints()
    if i == N % if end cell (no downstream cell)
      xi = hi;
      out(hi,xi) = dhdx_h7a_fout_i_k();
      xi = idxfn(k,'del',i);
      out(hi,xi) = dhdx_h7a_del_N_k();
    else % TODO: THIS NEEDS TO BE CHECKED
      xi = hi;
      out(hi,xi) = dhdx_h7a_fout_i_k();
      del = states.demand(kk,i);
      fin = states.fluxIn(kk,i+1);
      beta = scen.BC.beta(kk,i+1);
      d = states.rampDemand(kk,i+1);

      xi = idxfn(k,'del',i);
      out(hi,xi) = dhdx_h7a_del_i_k(beta,fin,del,d);
      
      xi = idxfn(k,'fin',i+1);
      out(hi,xi) = dhdx_h7a_fin_ip1_k(beta,fin,del,d);
      
      xi = idxfn(k,'d',i);
      out(hi,xi) = dhdx_h7a_d_i_k(beta,fin,del,d);
    end % END OF CHECK
  end

  function rConstraints()
    if i == 1 % if first cell (no upstream cell)
      xi = hi;
      out(hi,xi) = dhdx_h8_r_i_k();
      xi = idxfn(k,'fin',i);
      out(hi,xi) = dhdx_h8_fin_1_k();
    else % TODO: THIS NEEDS TO BE CHECKED
      xi = hi;
      out(hi,xi) = dhdx_h8_r_i_k();
      beta = scen.BC.beta(kk,i);
      xi = idxfn(k,'fin',i);
      out(hi,xi) = dhdx_h8_fin_ip1_k();
      xi = idxfn(k,'fout',i-1);
      out(hi,xi) = dhdx_h8_fout_i_k(beta);
    end % END OF CHECK
  end

end
