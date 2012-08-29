% wrapper script to test the gradient decent code
N=4;
T=3;
C=8;
R=1;
alpha=0.1;
params = struct('N', N, 'T', T, 'C', C, 'R', R, 'alpha', alpha, 'iter', 1);
lambda = ones(1,T*C*N);
u=ones(T,(N-1));
l=2*ones(T,(N-1));
for i=1:15
    partialJ_u = computePartialJ_u(R,u,l);
    diagOfPartialH5_u = computePartialH5_u(u,l);
    u_updated = gradDecent(u, partialJ_u, diagOfPartialH5_u, lambda, params);
    u = u_updated;
    u
end

    