function [ind,vlist] = data_sb(n,b)

vlist = zeros(n,n);
v = [ones(1,b) zeros(1,n-b)];

for i = 1:n   
    vlist(i,:) = circshift(v,i-1);    
end

ind = bi2de(vlist);
ind = ind.'+1;

end