function varargout = gradientDescent(u0, cost, gradient, maxIter, lineSearch, stop)

iteration = 0;
u = u0;
totCost = [];
global u12;
global u_rho_l;
u_rho_l = [];

while iteration < maxIter
    iteration = iteration + 1
    grad = gradient(u);
    nextU = lineSearch(u, grad, cost, iteration);
    if stop(u, nextU, iteration)
        u = nextU;
        break;
    end
    u = nextU;
    c = cost(u);
    disp(c);
    totCost(iteration) = c;
end

varargout{1} = u;
varargout{2} = totCost;

end