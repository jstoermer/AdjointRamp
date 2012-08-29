function out = supply(cell)
out = min(cell.fd.f_max, cell.fd.w*(cell.fd.rho_j -  cell.state.rho));
end