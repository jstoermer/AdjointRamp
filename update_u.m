function [ u_updated u_vect u_updated_vect] = update_u( t, gradJ_u, scen )
% Given the current control $u$ and the update parameters, output the 
% updated value of $u$
% u_updated = u - t*gradJ_u

u = scen.u;
l = scen.states.ramp_queues;
u_vect = reshape(u',1,scen.T*(scen.N-1));
u_updated_vect = u_vect - t*gradJ_u;
% Check whether doing the max here makes sense with backtracking line
% search
u_updated_vect = max(u_updated_vect,0);
% l = cell2mat({scen.states.ramp_queues}');
% l_vect = reshape(l(1:scen.T,:)',1,scen.T*(scen.N-1));
% u_updated_vect = min(u_updated_vect,l_vect-0.000001);
% u_updated_vect = max(u_updated_vect,0);
u_updated = reshape(u_updated_vect, scen.N-1, scen.T)';

end

