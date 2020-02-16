function list = bi2de(mat)

runs = size(mat,1);
n = size(mat,2);

list = sum( repmat(2.^[0:n-1],[runs 1]).*mat, 2 );

end