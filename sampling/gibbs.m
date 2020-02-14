function [vd,hd,vhd,vm,hm,vhm] = gibbs(a,b,w,k,v,prob)

n = length(a); m = length(b);
runs = size(v,1);
a = repmat(a, [runs 1]); b = repmat(b, [runs 1]);

vlist = zeros(runs,n,k);
hlist = zeros(runs,m,k);

vhd = zeros(n,m);
vhm = zeros(n,m);

for ki = 1:k    
    
    theta = v*w + b;
    hp = exp(theta)./(1+exp(theta));
    h = floor(hp + rand(runs,m));
    hlist(:,:,ki) = h;
    
    phi = (w*h.').' + a;
    vp = exp(phi)./(1+exp(phi));
    v = floor(vp + rand(runs,n));
    vlist(:,:,ki) = v;
    
    if ki == 1
        hpp = hp;
    end
    if ki == k
        vpp = vp;
    end
    
end

if prob
    vlist(:,:,end) = vpp;
end

for run = 1:runs
vhd = vhd + v(run,:).'*hpp(run,:);
for ki = 1:k
    vhm = vhm + vlist(run,:,ki).'*hlist(run,:,ki);
end
end
vhm = vhm/(runs*k);
vhd = vhd/runs;

vd = mean(v,1); 
hd = mean(hpp,1); 

vm = mean(vlist,[1 3]); 
hm = mean(hlist,[1 3]); 

end