function out = dJ_dx(N, T)
n =  (T+1) * N * 8;
out = sparse(n,1);

for k = 1:T+1
    for i = 1:N
        out(idx(N,k,'rho',i)) = 1;
    end
    for i = 1:N
        out(idx(N,k,'l',i)) = 1;
    end
end

end
