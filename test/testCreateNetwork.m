function testCreateNetwork

% CREATE SAMPLE SCENARIOS.
smallScen = createScenario(4, 12);
interScen = createScenario(8, 24);
largeScen = createScenario(12, 36);

% TEST THAT EACH SCENARIO HAS THE CORRECT NUMBER OF LINKS.
assertEqual(length(smallScen.links), 4);
assertEqual(length(interScen.links), 8);
assertEqual(length(largeScen.links), 12);

% TEST THAT ALL THE LINKS IN EACH SCENARIO HAS CORRECT VALUES FOR EACH
% PROPERTY. IN ADDITION, TEST THAT THE INITIAL CONDITIONS ARE CORRECT.
for i = 1:4
    assertTrue(smallScen.links(i).w >= 0.5 && smallScen.links(i).w <= 1);
    assertEqual(smallScen.links(i).v, 1);
    assertTrue(smallScen.links(i).fm >= 0.5 && smallScen.links(i).fm <= 1);
    assertEqual(smallScen.links(i).p, 0.8);
    assertEqual(smallScen.links(i).L, 1);
    pc = smallScen.links(i).fm / smallScen.links(i).v;
    assertEqual(smallScen.links(i).pc, pc);
    pm = smallScen.links(i).fm / smallScen.links(i).w + pc;
    assertEqual(smallScen.links(i).pm, pm);
    assertTrue(smallScen.IC.l0(i) <= 1);
    assertTrue(smallScen.IC.p0(i) <= 1);
end % for i

for i = 1:8
    assertTrue(interScen.links(i).w >= 0.5 && interScen.links(i).w <= 1);
    assertEqual(interScen.links(i).v, 1);
    assertTrue(interScen.links(i).fm >= 0.5 && interScen.links(i).fm <= 1);
    assertEqual(interScen.links(i).p, 0.8);
    assertEqual(interScen.links(i).L, 1);
    pc = interScen.links(i).fm / interScen.links(i).v;
    assertEqual(interScen.links(i).pc, pc);
    pm = interScen.links(i).fm / interScen.links(i).w + pc;
    assertEqual(interScen.links(i).pm, pm);
    assertTrue(interScen.IC.l0(i) <= 1);
    assertTrue(interScen.IC.p0(i) <= 1);
end % for i

for i = 1:12
    assertTrue(largeScen.links(i).w >= 0.5 && largeScen.links(i).w <= 1);
    assertEqual(largeScen.links(i).v, 1);
    assertTrue(largeScen.links(i).fm >= 0.5 && largeScen.links(i).fm <= 1);
    assertEqual(largeScen.links(i).p, 0.8);
    assertEqual(largeScen.links(i).L, 1);
    pc = largeScen.links(i).fm / largeScen.links(i).v;
    assertEqual(largeScen.links(i).pc, pc);
    pm = largeScen.links(i).fm / largeScen.links(i).w + pc;
    assertEqual(largeScen.links(i).pm, pm);
    assertTrue(largeScen.IC.l0(i) <= 1);
    assertTrue(largeScen.IC.p0(i) <= 1);
end % for i

% TEST THAT THE BOUNDARY CONDITIONS ARE CORRECT.
assertEqual(sum(sum(smallScen.BC.beta <= 1)), 48);
assertEqual(sum(sum(interScen.BC.beta <= 1)), 192);
assertEqual(sum(sum(largeScen.BC.beta <= 1)), 432);

% NOTE: The values for ...BC.beta should be less than or equal to 1
% everywhere. Therefore, sum(sum(...BC.beta <= 1)) should be equal to
% number of elements in ...BC.beta.

% TEST THAT THE NETWORK CLEARS AFTER COMPLETING A FORWARD SIMULATION.
uSmall = chooseInitialU(smallScen);
smallOutput = forwardSimulation(smallScen, uSmall);
assertTrue(sum(smallOutput.density(end, :)) < 1e-8);

uInter = chooseInitialU(interScen);
interOutput = forwardSimulation(interScen, uInter);
assertTrue(sum(interOutput.density(end, :)) < 1e-8);

uLarge = chooseInitialU(largeScen);
largeOutput = forwardSimulation(largeScen, uLarge);
assertTrue(sum(largeOutput.density(end, :)) < 1e-8);

end % function