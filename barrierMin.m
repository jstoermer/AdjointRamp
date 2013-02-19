function out = barrierMin(x, a)
out = - log(max(x-a, 0));
out = sum(sum(out));
end
