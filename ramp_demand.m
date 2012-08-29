function out = ramp_demand(cell)
out = min(cell.props.u, cell.state.l);
end