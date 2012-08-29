function out = demand(cell)
out = min(cell.fd.f_max, cell.fd.v * cell.state.rho);
end