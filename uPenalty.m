function myPenalty = uPenalty(myScenario, u)

global parameters;
R = parameters.R;
dt = myScenario.dt;
rMax  = repmat([myScenario.links.rmax], myScenario.T, 1);

[numRowsU,numColsU] = size(u);

myPenalty = zeros(numRowsU, numColsU);

for i = 1:numRowsU    
    for j = 1:numColsU
        myPenalty(i,j) = 3 * R .* (max(u(i,j) - min(1./dt, rMax(i,j)), 0)).^3;
    end % end j for loop 
end % end i for loop

end % end myPenalty