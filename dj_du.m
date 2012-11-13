function out = dj_du(~, states, u)
global parameters;
R = parameters.R;
%Given the controls u, on-ramp queue lengths l and penalty term R, computes
% partialJ_u given by
% \frac{\partial J}{u_i(k)} = R \cdot \ind{u_i(k) \le l_i(k)}
uvec = u'; uvec = uvec(:);
lvec = states.queue(1:end-1,:)'; lvec = lvec(:);

out = sparse(R.*max(uvec - lvec, 0).^2);
end