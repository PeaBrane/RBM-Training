function [v0,h0] = SA(a,b,w,beta_list,t,T)

n = length(a); m = length(b);
runs = floor(T/t);

bmin = beta_list(1); 
bmax = beta_list(2);

v0 = zeros(1,n); 
h0 = zeros(1,m); 
Ebest = 0;

v = round(rand(runs,n));
Elist = zeros(1,runs);

for ti = 1:t 
    
    beta = bmin + (ti-1)/(t-1)*(bmax - bmin); 
    
    theta = v*w + b;
    h = logical(floor(exp(beta*theta.*(1-2*v))+rand(runs,m)));
    phi = (w*h.').';
    v = logical(floor(exp(beta*phi.*(1-2*h))+rand(runs,n)));

    for run = 1:runs
    Elist(run) = v(run,:)*a.' + h(run,:)*b.' + v(run,:)*w*h(run,:).';
    end
    
    [Emax,runmax] = max(Elist);
    if Emax >= Ebest
        Ebest = Emax;
        v0 = v(runmax,:);
        h0 = h(runmax,:);
    end
        
end
    
end