function out = barrierMaxGrad(x, a)
out =  1./(max(a-x,0));
end
