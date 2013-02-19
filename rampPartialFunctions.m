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

function varargout = dh_dx(scen, states, u)

dt = scen.dt;
T = scen.T;
N = scen.N;
n = scen.nConstraints;

rowInd = zeros(1, 4 * n);
colInd = zeros(1, 4 * n);
sparseVal = zeros(1, 4 * n);

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
%out = sparse(n,n);
hi = 0;

rhoConstrToc = [];
lConstrToc = [];
delConstrToc = [];
sigConstrToc = [];
dConstrToc = [];
fInConstrToc = [];
fOutConstrToc = [];
rConstrToc = [];

forTic = tic;
indexCount = 0;
for k = 1:T+1 % time step iterator
    kk = min(k,T); % necessary iterator for T+1 flux boundary conditions
    for ci = 1:8
        for i = 1:N % cell iterator
            hi = hi +1;
            indexCount = indexCount + 1;
            rowInd(indexCount) = hi;
            colInd(indexCount) = hi;
            sparseVal(indexCount) = 1;
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
forToc = toc(forTic);

    function rhoConstraints()
        t1 = tic;
        if k == 1; return; end;
        %out(hi,N*8*(k - 1 - 1) + N*(1 -1) + i) = -1;
        indexCount = indexCount + 1;
        rowInd(indexCount) = hi;
        colInd(indexCount) = N*8*(k - 1 - 1) + N*(1 - 1) + i;
        sparseVal(indexCount) = -1;
        l = Lmat(i);
        %out(hi,N*8*(k - 1 - 1) + N*(6 -1) + i) = -dt / l;
        indexCount = indexCount + 1;
        rowInd(indexCount) = hi;
        colInd(indexCount) = N*8*(k - 1 - 1) + N*(6 - 1) + i;
        sparseVal(indexCount) = -dt / l;
        %out(hi,N*8*(k - 1 - 1) + N*(7 -1) + i) = dt / l;
        indexCount = indexCount + 1;
        rowInd(indexCount) = hi;
        colInd(indexCount) = N*8*(k - 1 - 1) + N*(7 - 1) + i;
        sparseVal(indexCount) = dt / l;
        rhoConstrToc = [rhoConstrToc, toc(t1)];
    end
    function lConstraints()
        t2 = tic;
        if k == 1; return; end;
        %out(hi,N*8*(k - 1 - 1) + N*(2 -1) + i) = -1;
        indexCount = indexCount + 1;
        rowInd(indexCount) = hi;
        colInd(indexCount) = N*8*(k - 1 - 1) + N*(2 - 1) + i;
        sparseVal(indexCount) = -1;
        %out(hi,N*8*(k - 1 - 1) + N*(8 -1) + i) = dt;
        indexCount = indexCount + 1;
        rowInd(indexCount) = hi;
        colInd(indexCount) = N*8*(k - 1 - 1) + N*(8 - 1) + i;
        sparseVal(indexCount) = dt;
        lConstrToc = [lConstrToc, toc(t2)];
    end
    function delConstraints()
        t3 = tic;
        rho = density(k,i);
        v = vmat(i);
        F = Fmat(i);
        if rho * v < F
            %out(hi,N*8*(k - 1) + N*(1 -1) + i) = -v;
            indexCount = indexCount + 1;
            rowInd(indexCount) = hi;
            colInd(indexCount) = N*8*(k - 1) + N*(1 - 1) + i;
            sparseVal(indexCount) = -v;
        end
        delConstrToc = [delConstrToc, toc(t3)];
    end
    function sigConstraints()
        t4 = tic;
        rho = density(k,i);
        w = wmat(i);
        rho_j = pmmat(i);
        F = Fmat(i);
        if w* ( rho_j - rho) < F
            %out(hi,N*8*(k  - 1) + N*(1 -1) + i) = w;
            indexCount = indexCount + 1;
            rowInd(indexCount) = hi;
            colInd(indexCount) = N*8*(k - 1) + N*(1 - 1) + i;
            sparseVal(indexCount) = w;
        end
        sigConstrToc = [sigConstrToc, toc(t4)];
    end
    function dConstraints()
        t5 = tic;
        l = queue(k,i);
        rmax = rmaxmat(i);
        uVal = u(kk,i);
        if l /dt <= min(uVal, rmax)
            %out(hi, N*8*(k - 1) + N*(2 -1) + i) = -1 / dt;
            indexCount = indexCount + 1;
            rowInd(indexCount) = hi;
            colInd(indexCount) = N*8*(k - 1) + N*(2 - 1) + i;
            sparseVal(indexCount) = -1 / dt;
        end
        dConstrToc = [dConstrToc, toc(t5)];
    end
    function fInConstraints()
        t6 = tic;
        if i == 1 % if first cell (no upstream mainline)
            d = rampDemand(kk,1);
            sig = supply(kk,1);
            if d < sig
                %out(hi,N*8*(k- 1) + N*(5 -1) + 1) = -1;
                indexCount = indexCount + 1;
                rowInd(indexCount) = hi;
                colInd(indexCount) = N*8*(k - 1) + N*(5 - 1) + 1;
                sparseVal(indexCount) = -1;
            else
                %out(hi, N*8*(k - 1) + N*(4 -1) + 1) = -1;
                indexCount = indexCount + 1;
                rowInd(indexCount) = hi;
                colInd(indexCount) = N*8*(k - 1) + N*(4 - 1) + 1;
                sparseVal(indexCount) = -1;
            end
        else
            del = demand(kk,i-1);
            sig = supply(kk,i);
            beta = betamat(kk,i);
            d = rampDemand(kk,i);
            if del*beta + d < sig
                %out(hi, N*8*(k - 1) + N*(3 -1) + i-1) = -beta;
                indexCount = indexCount + 1;
                rowInd(indexCount) = hi;
                colInd(indexCount) = N*8*(k - 1) + N*(3 - 1) + i - 1;
                sparseVal(indexCount) = -beta;
                %out(hi, N*8*(k - 1) + N*(5 -1) + i) = -1;
                indexCount = indexCount + 1;
                rowInd(indexCount) = hi;
                colInd(indexCount) = N*8*(k - 1) + N*(5 - 1) + i;
                sparseVal(indexCount) = -1;
            else
                %out(hi, N*8*(k - 1) + N*(4 -1) + i) = -1;
                indexCount = indexCount + 1;
                rowInd(indexCount) = hi;
                colInd(indexCount) = N*8*(k - 1) + N*(4 - 1) + i;
                sparseVal(indexCount) = -1;
            end
        end
        fInConstrToc = [fInConstrToc, toc(t6)];
    end
    function fOutConstraints()
        t7 = tic;
        if i == N % if end cell (no downstream cell)
            %out(hi,N*8*(k  - 1) + N*(3 -1) + N) = -1;
            indexCount = indexCount + 1;
            rowInd(indexCount) = hi;
            colInd(indexCount) = N*8*(k  - 1) + N*(3 - 1) + N;
            sparseVal(indexCount) = -1;
        else
            del = demand(kk,i);
            fin = fluxIn(kk,i+1);
            beta = betamat(kk,i+1);
            d = rampDemand(kk,i+1);
            p = pmat(i);
            sig = supply(kk,i+1);
            if sig * p / (1 + p) >= del * beta
                %out(hi, N*8*(k - 1) + N*(3 -1) + i) = -1;
                indexCount = indexCount + 1;
                rowInd(indexCount) = hi;
                colInd(indexCount) = N*8*(k - 1) + N*(3 - 1) + i;
                sparseVal(indexCount) = -1;
            elseif sig / (1 + p) >= d
                %out(hi,N*8*(k - 1) + N*(6 -1) + i+1) = - 1 / beta;
                indexCount = indexCount + 1;
                rowInd(indexCount) = hi;
                colInd(indexCount) = N*8*(k - 1) + N*(6 - 1) + i + 1;
                sparseVal(indexCount) = -1 / beta;
                %out(hi,N*8*(k - 1) + N*(5 -1) + i+1) = 1 / beta;
                indexCount = indexCount + 1;
                rowInd(indexCount) = hi;
                colInd(indexCount) = N*8*(k - 1) + N*(5 - 1) + i + 1;
                sparseVal(indexCount) = 1 / beta;
            else
                %out(hi, N*8*(k - 1) + N*(4 -1) + i+1) = -p / ((1 + p)*beta);
                indexCount = indexCount + 1;
                rowInd(indexCount) = hi;
                colInd(indexCount) = N*8*(k - 1) + N*(4 - 1) + i + 1;
                sparseVal(indexCount) = -p / ((1 + p)*beta);
            end
        end
        fOutConstrToc = [fOutConstrToc, toc(t7)];
    end
    function rConstraints()
        t8 = tic;
        %out(hi,N*8*(k - 1) + N*(6 -1) + i) = -1;
        indexCount = indexCount + 1;
        rowInd(indexCount) = hi;
        colInd(indexCount) = N*8*(k - 1) + N*(6 - 1) + i;
        sparseVal(indexCount) = -1;
        if i > 1
            %out(hi,N*8*(k - 1) + N*(7 -1) + i-1) = betamat(kk,i);
            indexCount = indexCount + 1;
            rowInd(indexCount) = hi;
            colInd(indexCount) = N*8*(k - 1) + N*(7 - 1) + i - 1;
            sparseVal(indexCount) = betamat(kk, i);
        end
        rConstrToc = [rConstrToc, toc(t8)];
    end

% rhoConstrAvg = mean(rhoConstrToc);
% lConstrAvg = mean(lConstrToc);
% delConstrAvg = mean(delConstrToc);
% sigConstrAvg = mean(sigConstrToc);
% dConstrAvg = mean(dConstrToc);
% fInConstrAvg = mean(fInConstrToc);
% fOutConstrAvg = mean(fOutConstrToc);
% rConstrAvg = mean(rConstrToc);
rhoConstrSum = sum(rhoConstrToc);
lConstrSum = sum(lConstrToc);
delConstrSum = sum(delConstrToc);
sigConstrSum = sum(sigConstrToc);
dConstrSum = sum(dConstrToc);
fInConstrSum = sum(fInConstrToc);
fOutConstrSum = sum(fOutConstrToc);
rConstrSum = sum(rConstrToc);

lastInds = [find(rowInd, 1, 'last'), find(colInd, 1, 'last'), find(sparseVal, 1, 'last')];
lastInd = max(lastInds);

rowInd = rowInd(1:lastInd);
colInd = colInd(1:lastInd);

sparseTic = tic;
sparseVal = sparseVal(1:lastInd);
sparseToc = toc(sparseTic);

out = sparse(rowInd, colInd, sparseVal);
%disp(['length(rowInd) = ', num2str(length(rowInd))]);

varargout{1} = out;
varargout{2} = [forToc, sparseToc, rhoConstrSum, lConstrSum, delConstrSum, sigConstrSum, ...
    dConstrSum, fInConstrSum, fOutConstrSum, rConstrSum];

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
barrierSum = barrierMaxGrad(u, .1 + min(rMax, states.queue(1:end-1,:)));
% barrierSum = barrierSum + barrierMinGrad(u, 0);

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


