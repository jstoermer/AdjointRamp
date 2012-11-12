function out = dh_du(u,l)
[T,N] = size(u);
n = (T+1)*N*8;
nu = T*N;
c = 'd';
eps = 0.000;

out = sparse(n,nu);

for k = 1:T
  for i = 1:N
    hi = idx(N,k,c,i);
    ui = k * i;
    if (u(k,i) < l(k,i))
      out(hi,ui) = -1;
    end
  end
end
end