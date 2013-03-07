function testConvertBeatsToScenario

% LOAD SAMPLE SCENARIOS.
smallTestTic = tic;
smallTest = io.convertBeatsToScenario('../networks/smalltest.xml');
smallTestToc = toc(smallTestTic);
disp(['Scenario for smallTest was generated in ', num2str(smallTestToc), ' seconds.']);

smallTestVaryTic = tic;
smallTestVary = io.convertBeatsToScenario('../networks/smallTestVary.xml');
smallTestVaryToc = toc(smallTestVaryTic);
disp(['Scenario for smallTestVary was generated in ', num2str(smallTestVaryToc), ' seconds.']);

% TEST THAT EACH SCENARIO HAS THE CORRECT NUMBER OF LINKS.
assertEqual(length(smallTest.links), smallTest.N);
assertEqual(length(smallTestVary.links), smallTestVary.N);

% TEST THAT EACH SCENARIO HAS THE CORRECT NUMBER OF TIME STEPS.
assertEqual(smallTest.T, 156);
assertEqual(smallTestVary.T, 215);

% TEST THAT THE CFL CONDITION IS SATISFIED FOR EACH LINK.
for i = 1:length(smallTest.N)
    assertTrue(smallTest.links(i).v / smallTest.links(i).L <= 1);
end

for i = 1:length(smallTestVary.N)
    assertTrue(smallTestVary.links(i).v / smallTestVary.links(i).L <= 1);
end

% TEST THAT THE DIMENSIONS OF THE DEMAND AND SPLIT RATIO MATRICES ARE
% CORRECT.
assertEqual(size(smallTest.BC.D), [smallTest.T, smallTest.N]);
assertEqual(size(smallTest.BC.beta), [smallTest.T, smallTest.N]);
assertEqual(size(smallTestVary.BC.D), [smallTestVary.T, smallTestVary.N]);
assertEqual(size(smallTestVary.BC.beta), [smallTestVary.T, smallTestVary.N]);

% TEST THAT THE SPLIT RATIOS NEVER EXCEED 1.
for i = 1:length(smallTest.T)
    for j = 1:length(smallTest.N)
        assertTrue(smallTest.BC.beta(i,j) <= 1)
    end
end

for i = 1:length(smallTestVary.T)
    for j = 1:length(smallTestVary.N)
        assertTrue(smallTestVary.BC.beta(i,j) <= 1)
    end
end

% TEST THAT THE DIMENSIONS OF THE INITIAL QUEUE AND DENSITY ARRAYS ARE
% CORRECT.
assertEqual(size(smallTest.IC.l0), [1, smallTest.N]);
assertEqual(size(smallTest.IC.p0), [1, smallTest.N]);
assertEqual(size(smallTestVary.IC.l0), [1, smallTestVary.N]);
assertEqual(size(smallTestVary.IC.p0), [1, smallTestVary.N]);

% TEST THAT THE DENSITY CLEARS AFTER A FORWARD SIMULATION.
uSmallTest = chooseInitialU(smallTest);
outSmallTest = forwardSimulation(smallTest, uSmallTest);
assertTrue(sum(outSmallTest.demand(end, :)) <= 1);

uSmallTestVary = chooseInitialU(smallTestVary);
outSmallTestVary = forwardSimulation(smallTestVary, uSmallTestVary);
assertTrue(sum(outSmallTestVary.demand(end, :)) <= 1);

% DISPLAY COMPLETION MESSAGE.
disp('All tests were completed successfully.');