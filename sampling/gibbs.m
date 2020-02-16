function [vd,hd,vhd,vm,hm,vhm] = gibbs(a,b,w,k,v0,smooth)

runs = size(v0,1);
n = length(a); m = length(b);
a = repmat(a, [runs 1]); b = repmat(b, [runs 1]);
v = v0;

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

if smooth
    vlist(:,:,end) = vpp;
end

for run = 1:runs
vhd = vhd + v0(run,:).'*hpp(run,:);
for ki = 1:k
    vhm = vhm + vlist(run,:,ki).'*hlist(run,:,ki);
end
end
vhd = vhd/runs;
vhm = vhm/(runs*k);

vd = mean(v0,1); 
hd = mean(hpp,1); 

vm = mean(vlist,[1 3]); 
hm = mean(hlist,[1 3]); 

end