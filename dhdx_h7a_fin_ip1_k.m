function out = dhdx_h7a_fin_ip1_k(beta, fin, del, d)
% HACK
p = .5;
if beta > 0
    if fin < (1 - beta) * del
        out = -1 / (1 - beta);
    else
        out = 0;
    end
else
    if fin > del / p
        out = 0;
    elseif fin > d / (1 - p)
        out = -1 / (1 - beta);
    else
        out = -p / (1 - beta);
    end    
end     
end