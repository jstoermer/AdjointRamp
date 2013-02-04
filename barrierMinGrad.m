function out = barrierMinGrad(x, a)
out = -1./(max(x-a,0));
end
