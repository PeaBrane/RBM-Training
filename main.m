%%%%%   Initialization   %%%%%

addpath(genpath('.'));
clear;
rng(0);

%%%%% Network Parameters %%%%%

n = 9;
m = 4;
nd = 3;
w_ini = 0.01;

%%%%% Training Parameters %%%%

epochs = 50000;

%%%%% CD-k Parameters %%%%%

lmax = 2*10^-1;
lmin = 2*10^-1;
ldecay = 0.2*epochs;
k = 3;
prob = true;

%%%%% SA Parameters %%%%%

SA_t = 1000;
SA_T = 10000;

%%%%% Mode Parameters %%%%%

% kmax = 0.01;
% kmin = 0.01;
% kl = 0.2*n_iter; % 300
% mode_step_max = 200; % 200
% mode_life = Inf; % 2000
% mode_step_min = 50; % 50
% mode_tau = 0.05*n_iter;
% mode_t0 = 0.5*n_iter; % 0.5*n_iter
% mode_pmax = 0.1;
% n_monte3 = 1;
% mode_ratio = 1; % 0.1
% mode_num = 1;
% opt_ratio = 10^-1;

%%%%% Plot Parameters %%%%%

interval = 100;

%%%%% Network Parameter Initialization %%%%%

a = w_ini*(-1+2*rand(1,n));
b = w_ini*(-1+2*rand(1,m));
w = w_ini*(-1+2*rand(n,m));

%%%%% Data Set %%%%%

[ind,vdata] = data_sb(n,1);

%%%%% Monitoring Lists %%%%%

KL_list = [];

%%%%% Update %%%%%

for ep = 1:epochs
    
lambda = lmax - (lmax - lmin)*ep/epochs;

[vd,hd,vhd,vm,hm,vhm] = gibbs(a,b,w,k,vdata,prob);

grada = lambda*(vd - vm); 
gradb = lambda*(hd - hm); 
gradw = lambda*(vhd - vhm);

a = a + grada; 
b = b + gradb; 
w = w + gradw;

if ~mod(ep,interval)
    [p,KL] = get_KL(vdata, a, b, w);
    KL_list = [KL_list KL];
end

end

plot(KL_list);