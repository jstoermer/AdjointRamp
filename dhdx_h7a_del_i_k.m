function out = dhdx_h7a_del_i_k(beta, fin, del, d)
% HACK
p = .5;
if beta > 0
    if fin < (1 - beta) * del
        out = 0;
    else
        out = -1 / (1 - beta);
    end
else
    if fin > del / p
        out = -1 / (1 - beta);
    elseif fin > d / (1 - p)
        out = 0;
    else
        out = 0;
    end    
end     
end