function [ind,vlist] = data_rand(n,k)

ind = randsample(0:2^n-1, k).';
vlist = de2bi(ind,n);
ind = ind+1;

end