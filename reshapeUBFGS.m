function out = reshapeUBFGS(u, scen)
out = reshape(u, scen.N-1, scen.T)';
end