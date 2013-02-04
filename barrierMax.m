function out = barrierMax(x, a)
out = - log(max(a-x,0));
out = sum(sum(out));
end
