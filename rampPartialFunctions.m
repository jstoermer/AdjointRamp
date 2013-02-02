function fns = rampPartialFunctions

fns.dhdx = @dh_dx;
fns.djdx = @dJ_dx;
fns.dhdu = @dh_du;
fns.djdu = @dJ_du_barrier;
end


function out = dh_du(scen, states, u)
T = scen.T; N = scen.N;
out = sparse(N*(T+1)*8, N*T);
for k = 1:T
  for i = 1:N
    l = states.queue(k,i);
    rmax = scen.links(i).rmax;
    u_cur = u(k,i);
    if u_cur < min(l / scen.dt, rmax)
      out(8*N*(k - 1) + N*(5 - 1) + i, N*(k - 1) + i) = -1;
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
hi = 0;

for k = 1:T+1 % time step iterator
  kk = min(k,T); % necessary iterator for T+1 flux boundary conditions
  for ci = 1:8
    for i = 1:N % cell iterator
      hi = hi +1;
      out(hi, hi) = 1;
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
    end
  end
end
  function rhoConstraints()
    if k == 1; return; end;
    out(hi,N*8*(k - 1 - 1) + N*(1 -1) + i) = -1;
    l = Lmat(i);
    out(hi,N*8*(k - 1 - 1) + N*(6 -1) + i) = -dt / l;
    out(hi,N*8*(k - 1 - 1) + N*(7 -1) + i) = dt / l;
  end
  function lConstraints()    
    if k == 1; return; end;
    out(hi,N*8*(k - 1 - 1) + N*(2 -1) + i) = -1;
    out(hi,N*8*(k - 1 - 1) + N*(8 -1) + i) = dt;
  end
  function delConstraints()
    rho = density(k,i);
    v = vmat(i);
    F = Fmat(i);
    if rho * v < F
      out(hi,N*8*(k - 1) + N*(1 -1) + i) = -v;
    end
  end
  function sigConstraints()
    rho = density(k,i);
    w = wmat(i);
    rho_j = pmmat(i);
    F = Fmat(i);
    if w* ( rho_j - rho) < F
      out(hi,N*8*(k  - 1) + N*(1 -1) + i) = w;
    end
  end
  function dConstraints()
    l = queue(k,i);
    rmax = rmaxmat(i);
    uVal = u(kk,i);
    if l /dt <= min(uVal, rmax)
      out(hi, N*8*(k - 1) + N*(2 -1) + i) = -1 / dt;
    end
  end
  function fInConstraints()
    if i == 1 % if first cell (no upstream mainline)
      d = rampDemand(kk,1);
      sig = supply(kk,1);
      if d < sig
        out(hi,N*8*(k- 1) + N*(5 -1) + 1) = -1;
      else
        out(hi, N*8*(k - 1) + N*(4 -1) + 1) = -1;
      end
    else
      del = demand(kk,i-1);
      sig = supply(kk,i);
      beta = betamat(kk,i);
      d = rampDemand(kk,i);
      if del*beta + d < sig
        out(hi, N*8*(k - 1) + N*(3 -1) + i-1) = -beta;
        out(hi, N*8*(k - 1) + N*(5 -1) + i) = -1;
      else
        out(hi, N*8*(k - 1) + N*(4 -1) + i) = -1;
      end
    end

  end
  function fOutConstraints()
    if i == N % if end cell (no downstream cell)
      out(hi,N*8*(k  - 1) + N*(3 -1) + N) = -1;
    else
      del = demand(kk,i);
      fin = fluxIn(kk,i+1);
      beta = betamat(kk,i+1);
      d = rampDemand(kk,i+1);
      p = pmat(i+1);
      sig = supply(kk,i+1);
      if del*beta + d <= sig || fin * p / beta >= del
        out(hi, N*8*(k - 1) + N*(3 -1) + i) = -1;
      elseif fin * (1 - p) >= d
        out(hi,N*8*(k - 1) + N*(6 -1) + i+1) = - 1 / beta;
        out(hi,N*8*(k - 1) + N*(5 -1) + i+1) = 1 / beta;
      else
        out(hi, N*8*(k - 1) + N*(4 -1) + i+1) = -p *beta;
      end
    end
  end
  function rConstraints()
    out(hi,N*8*(k - 1) + N*(6 -1) + i) = -1;
    if i > 1
      out(hi,N*8*(k - 1) + N*(7 -1) + i-1) = betamat(kk,i);
    end
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
  states.queue(1:end-1,:)./scen.dt),0)))');
end

function out = dJ_du_barrier(scen, states, u)
global parameters;
R = parameters.R;
%Given the controls u, on-ramp queue lengths l and penalty term R, computes
% partialJ_u given by
% \frac{\partial J}{u_i(k)} = R \cdot \ind{u_i(k) \le l_i(k)}
rMax  = repmat([scen.links.rmax], scen.T, 1);
barrierSum = minBarrierGrad(u, 0) + maxBarrierGrad(u, min(rMax, states.queue(1:end-1,:)));

out = sparse(...
  stacker(...
  R.*(barrierSum))');
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


function out = barrierMin(x, a)
out = - log(x-a);
out = sum(sum(out));
end

function out = barrierMax(x, a)
out = - log(a-x);
out = sum(sum(out));
end


function out = barrierMinGrad(x, a)
out = -1./(x-a);
end

function out = barrierMaxGrad(x, a)
out =  1./(a-x);
end


