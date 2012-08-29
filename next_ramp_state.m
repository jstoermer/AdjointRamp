function out = next_ramp_state(prev, f_in, f_out, dt)

out = prev + dt*(f_in - f_out);
end