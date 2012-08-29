function [ lambda5 ] = extractLambda5(lambda, params)
% Given the adjoint variable vector lambda, extracts only the variables
% corresponding to variable 5

lambda5 = lambda(params.N*4+1:params.N*5);
for i=1:params.T
    lambda5 = lambda5 + lambda(i*params.C*params.N + params.N*4+1: i*params.C*params.N + params.N*5)
end

