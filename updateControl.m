function [ u_updated ] = updateControl(u, l, lambda, scen)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
% params = struct('N', 'T', 'C', 'R', 'alpha', 'iter');

partialJ_u = computePartialJ_u(scen.R,u,l);
diagOfPartialH5_u = computePartialH5_u(u,l);
% Preform a single step of gradient decent
u_updated = gradDecent(u, partialJ_u, diagOfPartialH5_u, lambda, scen);

end

