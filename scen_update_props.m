function scen = scen_update_props(scen, t)
scen.dummy.props.D = scen.D0(t);
for i = 1:scen.N-1
    cell = scen.cells(i);
    u = scen.u(t,i);
    D = scen.D(t,i);
    beta = scen.beta(t,i);
    cell = cell_update_props(cell, u, D, beta);
    cells(i) = cell;
end
last_cell = scen.cells(end);
last_cell = cell_update_props(last_cell,0,0,0);
cells(end+1) = last_cell;
scen.cells = cells;
end

function cell = cell_update_props(cell, u, D, beta)
props.u = u;
props.D = D;
props.beta = beta;
cell.props = props;
end