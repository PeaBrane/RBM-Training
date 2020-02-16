function [p,KL] = get_KL(vdata, a, b, w)

runs = size(vdata,1); n = size(vdata,2);
vgen = de2bi([0:2^n-1].', n);
ind = bi2de(vdata).'+1;
q = 1/runs*ones(1,runs);

theta = vgen*w + repmat(b, [2^n 1]);
p = exp( vgen*a.' ) .* prod( 1+exp(theta) , 2 );
p = p.'/sum(p);

KL = sum( q.*log(q./p(ind)) );

end