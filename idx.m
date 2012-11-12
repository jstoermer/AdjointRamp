function out = idx(N,k,c,i)
C = 8;
if isstr(c)
    c = cmap(c);
end
out = (N*C)*(k - 1) + N*(c -1) + i;
end
