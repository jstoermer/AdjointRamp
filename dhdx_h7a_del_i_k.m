function out = dhdx_h7a_del_i_k(beta, fin, del, ramp_dem)
% HACK
p = .5;
if beta > 0
    if fin < (1 - beta) * del
        out = 0;
    else
        out = -1 / (1 - beta);
    end
else
    if p/(1-p) > del / (fin - (1 - beta)*del)
        out = -1 / (1 - beta);
    elseif p/(1-p) < (fin - ramp_dem) / ((1 - beta)*ramp_dem)
        out = 0;
    else
        out = 0;
    end    
end     
end