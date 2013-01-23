function [] = plotSweeps(outputStruct)

% If the variable is R, logarithmically plot the cost versus R. If the
% variable is the initial u, plot the cost versus trial.

numTrials = length(outputStruct);
myCost = [outputStruct.Cost];

if strcmp(outputStruct(1).Variable.Name, 'R-Value')
    R_temp = [outputStruct.Variable];
    R = [R_temp.Value];
    semilogx(R, myCost);
    title('Cost vs. \it{R}\rm-Value');
    xlabel('\it{R}\rm-Value');
    ylabel('Cost');
elseif strcmp(outputStruct(1).Variable.Name, 'Initial u-Value')
    plot(myCost);
    set(gca, 'XTick', 1:numTrials);
    title('Cost vs. Initial \it{u}\rm-Values');
    xlabel('Initial \it{u}\rm-Values Trial');
    ylabel('Cost');
else
    error('The argument, outputStruct, does not have a correct Name field for the Variable field.');
end % end if

end % end plotSweeps