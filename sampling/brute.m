function [v0,h0] = brute(a,b,w)

n = length(a); m = length(b);

vgen = de2bi([0:2^n-1].', n);
hgen = de2bi([0:2^m-1].', m);

Egen = repmat(vgen*a.', [1 2^m]) + repmat((hgen*b.').', [2^n 1])...
     + vgen*w*hgen.';
[~,ind0] = max(Egen,[],'all','linear');
[ii,jj] = ind2sub([2^n 2^m], ind0);

v0 = vgen(ii,:); h0 = hgen(jj,:);


end