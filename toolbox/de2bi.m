function mat = de2bi(list,n)

runs = size(list,1);
mat = zeros(runs,n);

quo = list;
for i = n:-1:1
   
   mat(:,i) = fix(quo/2^(i-1));
   quo = mod(quo,2^(i-1));
    
end

end