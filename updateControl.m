function [ u_updated ] = updateControl(lambda, scen)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
% params = struct('N', 'T', 'C', 'R', 'alpha', 'iter');

% Preform a single step of gradient decent using one of the following
% decent methods

%Gradient decent
u_updated = gradDecent(lambda, scen);

%Gradient decent with backtracking line search
%u_updated = backtrackingLineSearch(lambda, scen);

end

