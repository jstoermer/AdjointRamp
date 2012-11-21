function [out, lambda] = adjointGradient(dhdx, djdx, djdu, dhdu)
lambda = (dhdx' \ djdx');
out = (djdu - lambda'*dhdu)';
end