function out = cmap(str)
cs = {'rho','l','del','sig','d','fin','fout','r'};
out = find(ismember(cs, str),'first');
end