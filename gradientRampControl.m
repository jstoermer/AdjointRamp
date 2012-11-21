function [out info] = gradientRampControl(scen, states, u)
% Finds the gradient for a given scenario, control and resulting output state
fns = rampPartialFunctions;

dhdx = fns.dhdx(scen,states, u);
djdx = fns.djdx(scen,states, u);
djdu = fns.djdu(scen, states, u);
dhdu = fns.dhdu(scen, states, u);


% Compute the gradient
[u, lambda] = adjointGradient(dhdx, djdx, djdu, dhdu);

info.dhdx = dhdx;
info.djdx = djdx;
info.lambda = lambda;
info.djdu = djdu;
info.dhdu = dhdu;

out = u;

% disp('t1'); disp(full(unstack(t1,scen)));
% disp('t2'); disp(full(unstack(t2,scen)));
% disp('grad'); disp(full(unstack(out,scen)));
% disp('u'); disp(u);
end