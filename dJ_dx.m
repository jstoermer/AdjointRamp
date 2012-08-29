function out = dJ_dx(N, T)
n =  T * (8 * N - 1);
out = sparse(n,1);

for k = 0:T-1
    for i = 0:N
        out(idx_lookup(k,'rho',i,N)) = 1;
    end
    for i = 1:N-1
        out(idx_lookup(k,'l',i,N)) = 1;
    end
end

end
