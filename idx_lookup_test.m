clear all; clc; close all;
N = 5;
T = 4;
cs = {'rho','l','del','sig','d','fin','fout','r'};
cstart = [0,1,0,1,1,1,0,1];
cend = [N,N-1,N,N,N-1,N,N-1,N-1];
data = [];
for k = 0:T
    for ci = 1:8
        c = cs{ci};
        start = cstart(ci);
        finish = cend(ci);
        for i = start:finish
            data(end+1) = idx_lookup(k,c,i,N);
        end
    end
end
plot(diff(data));
        
