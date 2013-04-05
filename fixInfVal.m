function outVal = fixInfVal(inVal)
% If a value in the inVal array is Inf, it will be changed to twice the
% maximum of the finite values in the inVal array. For plotting purposes.

nonInf = inVal < Inf;
nonInfVal = inVal(nonInf);
finiteMax = max(nonInfVal);
if isempty(finiteMax)
   finiteMax = 1e4; 
end
outVal = inVal;

for i = 1:length(inVal)
    if inVal(i) == Inf
        outVal(i) = 10*finiteMax;
    end
end

end 