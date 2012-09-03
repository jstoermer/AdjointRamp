function [ diagOfPartialH5_u ] = computePartialH5_u(u, l)
%Given the controls u and on-ramp queue lengths l, computes
% partialH5_u given by 
% \frac{\partial H5}{u_i(k)} = R \cdot \ind{u_i(k) \le l_i(k)}
% Note: \frac{\partial H}{u_i(k)} is 0 elsewhere

[T, Nr] = size(u); 
diagOfPartialH5_u = zeros(1,T*Nr);
for i=1:T
    for k=1:Nr;
        if (u(i,k) <= l(i,k))
            % diagOfPartialH5_u is the diagonal of partialH5_u
            % HACK! remove this second if condition
%            if (u(i,k) > 0)
                diagOfPartialH5_u(1,(i-1)*Nr + k) = -1;
%            end
        end
    end
end
end

