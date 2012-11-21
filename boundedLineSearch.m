function out = boundedLineSearch(bottom, top, ls)
out = @ (u, gradient, cost, iteration) min(top, max(bottom,ls(u, gradient, cost, iteration)));
end
