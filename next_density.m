function out = next_density(prev,f_in,f_out,dt,dx)
out = prev + dt/dx*(f_in - f_out);
end