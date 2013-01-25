function varargout = gradientDescent(u0, cost, gradient, maxIter, lineSearch, stop)

iteration = 0;
u = u0;
totCost = [];
global u12;

while iteration < maxIter
    iteration = iteration + 1;
    grad = gradient(u);
    grad
    nextU = lineSearch(u, grad, cost, iteration);
    if stop(u, nextU, iteration)
        u = nextU;
        break;
    end
    u = nextU;
    totCost(iteration) = cost(u);
    u12(iteration) = u(2);
    u
end

varargout{1} = u;
varargout{2} = totCost;

end