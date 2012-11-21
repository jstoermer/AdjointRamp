function testStackUnstack

x = rand(20,7);
sx = stacker(x);
ssx = unstack(sx, 7, 20);

assertEqual(sx(6), x(1,6));
assertEqual(sx(8), x(2,1));
assertEqual(sx(7*11 + 5), x(12,5));

assertEqual(ssx, x);

assertEqual(sx(10), ssx(2, 3));


scen = loadScenario('../networks/samitha1onrampcomplex.json');

N = scen.N; T = scen.T;

x = rand(T,N);


sx = stacker(x);
ssx = unstack(sx, scen);

assertEqual(sx(3), x(1,3));
assertEqual(sx(N + 1), x(2,1));
assertEqual(sx(N*6 + 2), x(7,2));

assertEqual(ssx, x);

assertEqual(sx(N + 3), ssx(2, 3));




end