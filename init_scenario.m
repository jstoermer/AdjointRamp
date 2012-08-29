function s = init_scenario(scenario)
s = scenario;
s.dummy = dummy_cell();
for i = 1:s.N
    cell = s.cells(i);
    rho_0 = s.rho_0(i);
    l_0 = s.l_0(i);
    cell = init_state(cell, rho_0, l_0);
    % cell.s = s;
    cells(i) = cell;
end
s.cells = cells;
end