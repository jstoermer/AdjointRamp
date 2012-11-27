function out = bfgsCostWrapper(u)
global bfgsStore;
out = bfgsStore.evaluateCost(u);
end