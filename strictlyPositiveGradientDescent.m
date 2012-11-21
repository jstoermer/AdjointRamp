function out = strictlyPositiveGradientDescent(u0, objective, gradient)
global parameters;
out = gradientDescent(u0, objective, gradient, parameters.globalMaxIterations, boundedLineSearch(0,inf, @basicLineSearch), @stopIterating);
end