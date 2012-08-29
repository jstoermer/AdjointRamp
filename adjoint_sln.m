function out = adjoint_sln(scen,states)
N = scen.N; T = scen.T;
dhdx = dh_dx(scen,states);
djdx = dJ_dx(N,T);

out = dhdx \ djdx;

end

