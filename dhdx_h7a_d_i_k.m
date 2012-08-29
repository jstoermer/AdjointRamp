function out = dhdx_h7a_d_i_k(beta, fin, del, d)
% HACK
p = .5;
if beta > 0
    if fin < (1 - beta) * del
        out = 0;
    else
        out = 0;
    end
else
    if fin > del / p
        out = 0;
    elseif fin > d / (1 - p)
        out = 1;
    else
        out = 0;
    end    
end     
end