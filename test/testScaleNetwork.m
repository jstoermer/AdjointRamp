scen = createScenario(5,5);
u = noControlU(scen);
adjStruct = rampAdjointStructures(scen);

% prime the state
% time these two steps
adjStruct.structure.objective(u);
adjStruct.structure.gradient(u);
% for different sized networks

%check that it scales linearly

