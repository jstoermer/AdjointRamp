function [ lambda5 ] = extractLambda5(lambda, scen)
% Given the adjoint variable vector lambda, extracts only the variables
% corresponding to variable 5

lambda5 = [];
for k=0:scen.T-1
    % get_lambda() returns a vector of length N-1
    lambda5 = [lambda5; get_lambda_5k(scen, lambda, k)];
end


