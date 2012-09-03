function [ u_updated ] = updateControl(lambda, scen, iter)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
% params = struct('N', 'T', 'C', 'R', 'alpha', 'iter');

% Preform a single step of gradient decent
%u_updated = gradDecent(u, partialJ_u, diagOfPartialH5_u, lambda, scen);
u_updated = backtrackingLineSearch(lambda, scen, iter);
end

