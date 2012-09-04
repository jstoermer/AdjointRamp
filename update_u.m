function [ u_updated, u_vect, u_updated_vect ] = update_u( u, t, gradJ_u, scen )
% Given the current control $u$ and the update parameters, output the 
% updated value of $u$
% u_updated = u - t*gradJ_u

u_vect = reshape(u',1,scen.T*(scen.N-1));
u_updated_vect = u_vect - t*gradJ_u;
% Check whether doing the max here makes sense with backtracking line
% search
u_updated_vect = max(u_updated_vect,0);
%u_updated_vect = min(u_updated_vect,l_vect);
u_updated = reshape(u_updated_vect, scen.N-1, scen.T)';

end

