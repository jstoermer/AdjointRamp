function fns = rampPartialFunctions

fns.dhdx = @dh_dx;
fns.djdx = @dJ_dx;
fns.dhdu = @dh_du;
fns.djdu = @dJ_du;
end


function out = dh_du(scen, states, u)
T = scen.T; N = scen.N;
n = scen.nConstraints; nu = scen.nControls;
c = 5;
l = states.queue(1:end-1,:);

out = sparse(n,nu);
for k = 1:T
  for i = 1:N
    hi = idx(N,k,c,i);
    ui = uidx(N,k,i);
    uval = u(k,i);
    l = states.queue(k,i);
    rmax = scen.links(i).rmax;
    if uval < l / scen.dt && uval < rmax
      out(hi,ui) = -1;
    end
  end
end
end

function out = dh_dx(scen, states, u)

dt = scen.dt;
T = scen.T;
N = scen.N;
n = scen.nConstraints;
C = 8;
density = states.density;
vmat = zeros(N,1);
Fmat = zeros(N,1);
wmat = zeros(N,1);
Lmat = zeros(N,1);
pmmat = zeros(N,1);
pmat = zeros(N,1);
rmaxmat = zeros(N,1);
betamat = scen.BC.beta;
queue= states.queue;
rampDemand = states.rampDemand;
supply = states.supply;
demand = states.demand;
fluxIn = states.fluxIn;
for i = 1:N
  vmat(i) = scen.links(i).v;
  Fmat(i) = scen.links(i).fm;
  pmmat(i) = scen.links(i).pm;
  pmat(i) = scen.links(i).p;
  wmat(i) = scen.links(i).w;
  Lmat(i) = scen.links(i).L;
  rmaxmat(i) = scen.links(i).rmax;
end
out = sparse(n,n);
t1 = [];
hi = 0;

for k = 1:T+1 % time step iterator
  kk = min(k,T); % necessary iterator for T+1 flux boundary conditions
  for ci = 1:8
    for i = 1:N % cell iterator
%       tic;
      hi = hi +1;
      switch ci
        case 1; rhoConstraints();
        case 2; lConstraints();
        case 3; delConstraints();
        case 4; sigConstraints();
        case 5; dConstraints();
        case 6; fInConstraints();
        case 7; fOutConstraints();
        case 8; rConstraints();
      end
%       t1(N*(k -1) + i, ci) = toc;
    end
  end
end
% disp('hi');
% disp(sum(t1));
% disp(sum(sum(t1)));


  function rhoConstraints()
    if k == 1 % if initial condition (no 0 time)
      xi = hi;
      out(hi,xi) = dhdx_i1_rho_i_0();
    else % TODO: need to check block
      xi = hi;
      out(hi,xi) = dhdx_h1a_rho_i_k();
      xi = (N*C)*(k - 1 - 1) + N*(1 -1) + i;
      out(hi,xi) = dhdx_h1a_rho_i_km1();
      xi = (N*C)*(k - 1 - 1) + N*(7 -1) + i;
      l = Lmat(i);
      out(hi,xi) = dhdx_h1a_fout_i_km1(dt,l);
      xi = (N*C)*(k - 1 - 1) + N*(6 -1) + i;
      out(hi,xi) = dhdx_h1a_fin_i_km1(dt,l);
    end % end block

  end
  function lConstraints()
    if k == 1 % if initial condition (no 0 time)
      xi = hi;
      out(hi,xi) = dhdx_i2_l_i_0();
    else
      xi = hi;
      out(hi,xi) = dhdx_h2_l_i_k();
      xi = (N*C)*(k - 1-1) + N*(2 -1) + i;
      out(hi,xi) = dhdx_h2_l_i_km1();
      xi = (N*C)*(k - 1 -1) + N*(7 -1) + i;
      out(hi,xi) = dhdx_h2_r_i_k(dt);
    end
  end
  function delConstraints()
    xi = hi;
    out(hi,xi) = dhdx_h3_del_i_k();
    xi = (N*C)*(k - 1) + N*(1 -1) + i;
    rho = density(k,i);
    v = vmat(i);
    F = Fmat(i);
    out(hi,xi) = dhdx_h3_rho_i_k(rho,v,F);
  end
  function sigConstraints()
    xi = hi;
    out(hi,xi) = dhdx_h4_sig_i_k();
    xi = (N*C)*(k - 1) + N*(1 -1) + i;
    rho = density(k,i);
    w = wmat(i);
    rho_j = pmmat(i);
    F = Fmat(i);
    out(hi,xi) = dhdx_h4_rho_i_k(rho,w,rho_j,F);
  end
  function dConstraints()
    xi = hi;
    out(hi,xi) = dhdx_h5_d_i_k();
    xi = (N*C)*(k - 1) + N*(2 -1) + i;
    l = queue(k,i);
    rmax = rmaxmat(i);
    uVal = u(kk,i);
    out(hi,xi) = dhdx_h5_l_i_k(l,uVal, rmax, dt);

  end
  function fInConstraints()
    if i == 1 % if first cell (no upstream mainline)
      xi = hi;
      out(hi,xi) = dhdx_h6b_fin_1_k();

      d = rampDemand(kk,1);
      sig = supply(kk,1);

      xi = (N*C)*(k - 1) + N*(5 -1) + 1;
      out(hi,xi) = dhdx_h6b_d_1_k(d,sig);

      xi = (N*C)*(k - 1) + N*(4 -1) + 1;
      out(hi,xi) = dhdx_h6b_sig_1_k(d,sig);
    else
      xi = hi;
      out(hi,xi) = dhdx_h6a_fin_i_k();
      del = demand(kk,i-1);
      sig = supply(kk,i);
      beta = betamat(kk,i);
      d = rampDemand(kk,i);
      xi = (N*C)*(k - 1) + N*(3 -1) + i-1;
      out(hi,xi) = dhdx_h6a_del_im1_k(del,beta,d,sig);
      xi = (N*C)*(k - 1) + N*(4 -1) + i;
      out(hi,xi) = dhdx_h6a_sig_i_k(del,beta,d,sig);
      xi = (N*C)*(k - 1) + N*(5 -1) + i;
      out(hi,xi) = dhdx_h6a_d_im1_k(del,beta,d,sig);
    end

  end
  function fOutConstraints()
    if i == N % if end cell (no downstream cell)
      xi = hi;
      out(hi,xi) = dhdx_h7a_fout_i_k();
      xi = (N*C)*(k - 1) + N*(3 -1) + i;
      out(hi,xi) = dhdx_h7a_del_N_k();
    else % TODO: THIS NEEDS TO BE CHECKED
      xi = hi;
      out(hi,xi) = dhdx_h7a_fout_i_k();
      del = demand(kk,i);
      fin = fluxIn(kk,i+1);
      beta = betamat(kk,i+1);
      d = rampDemand(kk,i+1);
      p = pmat(i);

      xi = (N*C)*(k - 1) + N*(3 -1) + i;
      out(hi,xi) = dhdx_h7a_del_i_k(beta,fin,del,d, p);

      xi = (N*C)*(k - 1) + N*(6 -1) + i+1;
      out(hi,xi) = dhdx_h7a_fin_ip1_k(beta,fin,del,d, p);

      xi = (N*C)*(k - 1) + N*(5 -1) + i;
      out(hi,xi) = dhdx_h7a_d_i_k(beta,fin,del,d, p);
    end % END OF CHECK
  end
  function rConstraints()
    if i == 1 % if first cell (no upstream cell)
      xi = hi;
      out(hi,xi) = dhdx_h8_r_i_k();
      xi = (N*C)*(k - 1) + N*(6 -1) + i;
      out(hi,xi) = dhdx_h8_fin_1_k();
    else % TODO: THIS NEEDS TO BE CHECKED
      xi = hi;
      out(hi,xi) = dhdx_h8_r_i_k();
      beta = betamat(kk,i);
      xi = (N*C)*(k - 1) + N*(6 -1) + i;
      out(hi,xi) = dhdx_h8_fin_ip1_k();
      xi = (N*C)*(k - 1) + N*(7 -1) + i-1;
      out(hi,xi) = dhdx_h8_fout_i_k(beta);
    end % END OF CHECK
  end
end


function out = dJ_du(scen, states, u)
global parameters;
R = parameters.R;
%Given the controls u, on-ramp queue lengths l and penalty term R, computes
% partialJ_u given by
% \frac{\partial J}{u_i(k)} = R \cdot \ind{u_i(k) \le l_i(k)}
out = sparse(...
  stacker(...
  R.*(max(u -...
  min(repmat([scen.links.rmax], scen.T, 1),...
  states.queue(1:end-1,:)./scen.dt),0).^2))');
end

function out = dJ_dx(scen, ~, ~)
T = scen.T; N = scen.N;
n = scen.nConstraints;
out = sparse(1,n);

for k = 1:T+1
  for i = 1:N
    out(idx(N,k,1,i)) = scen.links(i).L * scen.dt;
  end
  for i = 1:N
    out(idx(N,k,2,i)) = scen.dt;
  end
end

end



function out = dhdx_h1a_fin_i_km1(dt,dx)
out = -dt/dx;
end
function out = dhdx_h1a_fout_i_km1(dt,dx)
out = dt/dx;
end
function out = dhdx_h1a_rho_i_k()
out = 1;
end
function out = dhdx_h1a_rho_i_km1()
out = -1;
end
function out = dhdx_h1b_fout_0_km1(dt,dx)
out = dt/dx;
end
function out = dhdx_h1b_rho_0_k()
out = 1;
end
function out = dhdx_h1b_rho_0_km1()
out = -1;
end
function out = dhdx_h1c_del_N_k(dt,dx)
out = dt/dx;
end
function out = dhdx_h1c_fout_N_km1(dt,dx)
out = -dt/dx;
end
function out = dhdx_h1c_rho_N_k()
out = 1;
end
function out = dhdx_h1c_rho_N_km1()
out = -1;
end
function out = dhdx_h2_l_i_k()
out = 1;
end
function out = dhdx_h2_l_i_km1()
out = -1;
end
function out = dhdx_h2_r_i_k(dt)
out = dt;
end
function out = dhdx_h3_del_i_k()
out = 1;
end
function out = dhdx_h3_rho_i_k(rho,v,F)
if v * rho < F
  out = -v;
else
  out = 0;
end
end
function out = dhdx_h4_rho_i_k(rho,w,rho_j,F)
if w*(rho_j - rho) < F
  out = w;
else
  out = 0;
end
end
function out = dhdx_h4_sig_i_k()
out = 1;
end
function out = dhdx_h5_d_i_k()
out = 1;
end
function out = dhdx_h5_l_i_k(l,u, rmax, dt);
if l / dt < u && l / dt < rmax
  out = -1 / dt;
else
  out = 0;
end
end
function out = dhdx_h6a_d_im1_k(del,beta,d,sig)
if (del) * (1 - beta) + d < sig
  out = -1;
else
  out = 0;
end
end
function out = dhdx_h6a_del_im1_k(del,beta,d,sig)
if (del) * (1 - beta) + d < sig
  out = -(1 - beta);
else
  out = 0;
end
end
function out = dhdx_h6a_fin_i_k()
out = 1;
end
function out = dhdx_h6a_sig_i_k(del,beta,d,sig)
if (del) * (1 - beta) + d >= sig
  out = -1;
else
  out = 0;
end
end
function out = dhdx_h6b_d_1_k(d,sig)
if (d) < sig
  out = -1;
else
  out = 0;
end
end
function out = dhdx_h6b_del_0_k(del,sig)
if (del) < sig
  out = -1;
else
  out = 0;
end
end
function out = dhdx_h6b_fin_1_k()
out = 1;
end
function out = dhdx_h6b_sig_1_k(d,sig)
if (d) >= sig
  out = -1;
else
  out = 0;
end
end
function out = dhdx_h7a_d_i_k(beta, fin, del, d, p)
if p * fin / ( 1- beta) > del
  out = 0;
elseif (1 - p) * fin > d
  out = 0;
else
  out = 1;
end
end
function out = dhdx_h7a_del_i_k(beta, fin, del, d, p)
if p * fin / ( 1- beta) > del
  out = -(1 - beta);
elseif (1 - p) * fin > d
  out = 0;
else
  out = 0;
end
end
function out = dhdx_h7a_del_N_k()
out = -1;
end
function out = dhdx_h7a_fin_ip1_k(beta, fin, del, d, p)
if p * fin / ( 1- beta) > del
  out = 0;
elseif (1 - p) * fin > d
  out = -p;
else
  out = 0;
end
end
function out = dhdx_h7a_fout_i_k()
out = 1;
end
function out = dhdx_h7b_fin_1_k()
out = -1;
end
function out = dhdx_h7b_fout_0_k()
out = 1;
end
function out = dhdx_h8_fin_1_k()
out = -1;
end
function out = dhdx_h8_fin_ip1_k()
out = -1;
end
function out = dhdx_h8_fout_i_k(beta)
out = (1 - beta);
end
function out = dhdx_h8_r_i_k()
out = 1;
end
function out = dhdx_i1_rho_i_0()
out = 1;
end
function out = dhdx_i2_l_i_0()
out = 1;
end