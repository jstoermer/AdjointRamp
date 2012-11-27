function out =  bfgsGradientWrapper(u)
global bfgsStore;
out = bfgsStore.evaluateGradient(u);
end