function outCost = infCostFix(inCost)
% If a value in the inCost array is Inf, it will be changed to twice the
% maximum of the finite values in the inCost array. For plotting purposes.

nonInf = find(inCost < Inf);
nonInfCost = inCost(nonInf);
finiteMax = max(nonInfCost);
outCost = inCost;

for i = 1:length(inCost)
    if inCost(i) == Inf
        outCost(i) = 2*finiteMax;
    end
end

end 