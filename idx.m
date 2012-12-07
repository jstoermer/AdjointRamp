function out = idx(N,k,c,i)
persistent cmap
C = 8;
if isempty(cmap)
  cmap = containers.Map({'rho','l','del','sig','d','fin','fout','r'}, [1:8]);
end
if isstr(c)
  c = cmap(c);
end
out = (N*C)*(k - 1) + N*(c -1) + i;
end
