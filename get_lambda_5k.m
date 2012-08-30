function out = get_lambda_5k(scen, lambda, k)
N = scen.N;
start = idx_lookup(k, 'd', 1,scen.N);
endi = idx_lookup(k, 'd', N - 1,scen.N);
out = lambda(start:endi);
end