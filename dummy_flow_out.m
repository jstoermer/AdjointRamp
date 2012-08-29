function out = dummy_flow_out(scen)

dem = demand(scen.dummy);
ds_cell = scen.cells(1);
sup = supply(ds_cell);
out = min(dem, sup);

end