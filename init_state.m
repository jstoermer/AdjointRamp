function hwcell = init_state(hwcell, rho, l)

state = cell_state(rho, l);
hwcell.state = state;

end
