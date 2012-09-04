function out = mpc(scen, u0, sim_k, hor_k)

main_scen = scen;
main_scen.states = init_state_collector();
k = 0; T = scen.T - 1;
k_start = k;
k_end_hor = k + hor_k - 1;
k_end_sim = k + sim_k - 1;

rho0 = scen.rho_0;
l0 = scen.l_0;

while true
    scen = scen_with_time_range(main_scen, k_start, k_end_hor, rho0, l0);
    u0_scen = u0(k_start+1:k_end_hor+1,:);
    u_opt = adjointBFGS(scen, u0_scen);
    
    scen = scen_with_time_range(main_scen, k_start, k_end_sim, rho0, l0);
    u_opt = u_opt(1:sim_k,:);
    scen.u = u_opt;
    scen = forward_sim(scen);
    
    rho0 = scen.states(end).densities;
    l0 = [scen.states(end).ramp_queues,0];
        
    main_scen = transfer_states(scen, main_scen,k);
    k = k_end_sim + 1;
    k_start = k;
    k_end_hor = k + hor_k - 1;
    k_end_sim = k + sim_k - 1;
    if k_start >= T
        break
    end
    if k_end_sim > T
        sim_k = T - k_start + 1;
        k_end_sim = T;
    end
    if k_end_hor > T
        hor_k = T - k_start + 1;
        k_end_hor = T;
    end
end

out = main_scen;
end

