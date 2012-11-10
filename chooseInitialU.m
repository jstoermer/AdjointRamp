function u = chooseInitialU(scen)

T = scen.T;
N = scen.N;

u = zeros(T,N);

for n = 1:N
    u(:, n) = scen.links(n).rmax* .5;
end
end
