function stop = stopIterating(u, nextU, iteration)
global parameters;
stop = (norm(nextU - u) < parameters.globalConvergenceThreshold) | (iteration > parameters.globalMaxIterations);
end