function [ partialJ_u ] = computePartialJ_u(R, u, l)
%Given the controls u, on-ramp queue lengths l and penalty term R, computes
% partialJ_u given by 
% \frac{\partial J}{u_i(k)} = R \cdot \ind{u_i(k) \le l_i(k)}

[T, Nr] = size(u); 
partialJ_u = zeros(T*Nr);
for i=1:T
    for k=1:Nr;
        if (u(i,k) >= l(i,k))
            partialJ_u((i-1)*Nr + k) = R;
        end
    end
end

end

