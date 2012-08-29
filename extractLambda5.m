function [ lambda5 ] = extractConstraint5(var, params)
% Given the adjoint variable vector lambda, extracts only the variables
% corresponding to variable 5

lambda5 = var(params.N*4+1:params.N*5);
for i=1:params.T
    [i,params.T,params.N,params.C]
    lambda5 = lambda5 + var((i-1)*params.C*params.N + params.N*4+1: (i-1)*params.C*params.N + params.N*5)
end

