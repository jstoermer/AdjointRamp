function [ u_updated ] = updateControl(lambda, scen)
% params = struct('N', 'T', 'C', 'R', 'alpha', 'iter');

% Preform a single step of gradient decent using one of the following
% decent methods

%Gradient decent
u_updated = gradDecent(lambda, scen);

%Gradient decent with backtracking line search
%u_updated = backtrackingLineSearch(lambda, scen);

end

