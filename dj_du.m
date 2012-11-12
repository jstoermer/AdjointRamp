function out = dj_du(R,u,l)
%Given the controls u, on-ramp queue lengths l and penalty term R, computes
% partialJ_u given by
% \frac{\partial J}{u_i(k)} = R \cdot \ind{u_i(k) \le l_i(k)}

[T, N] = size(u);
out = sparse(T*N,1);
for k=1:T
    for i=1:N;
        if (u(k,i) >= l(k,i))
            out((k-1)*N + i) = (R*(u(k,i) - l(k,i)))^2;
        end
    end
end
end