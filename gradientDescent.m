function out = gradientDescent(u0, cost, gradient, maxIter, lineSearch, stop)
iteration = 0;
u = u0;
while iteration < maxIter
    iteration = iteration + 1
    du = gradient(u)
    nextU = lineSearch(u, gradient(u), cost, iteration);
    if stop(u, nextU, iteration)
        u = nextU;
        break;
    end
    u = nextU;
    cost(u)
end
out = u;
end