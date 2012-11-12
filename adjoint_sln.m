function out = adjoint_sln(scen,states, u)
N = scen.N; T = scen.T;
dhdx = dh_dx(scen,states, u);
djdx = dJ_dx(N,T);

out = -1 .* dhdx' \ djdx;
end

