%%%%%   Initialization   %%%%%

addpath(genpath('.'));
clear;
rng(0);

%%%%% Network Parameters %%%%%

n = 9;
m = 12;
nd = 1;
w_ini = 0.01;
copies = 10;

%%%%% Training Parameters %%%%

epochs = 1000;

%%%%% CD-k Parameters %%%%%

lmax = 0.5*10^-1;
lmin = 0.5*10^-3;
ldecay = 0.2*epochs;
k = 1;
smooth = true;

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

interval = 1;

%%%%% Network Parameter Initialization %%%%%

alist = w_ini*(2*rand([1 n copies]));
blist = w_ini*(2*rand([1 m copies]));
wlist = w_ini*(2*rand([n m copies]));

%%%%% Data Set %%%%%

[ind,vdata] = data_sb(n,5);

%%%%% Monitoring Lists %%%%%

KL_list = zeros( copies, floor(epochs/interval) );
frus_list = zeros( copies, floor(epochs/interval) );

%%%%% Update %%%%%

c_monitor = 0;
for ep = 1:epochs
    
if ~mod(ep,interval)
    c_monitor = c_monitor + 1;
end
mydot(ep,epochs);
    
lambda = lmax - (lmax - lmin)*ep/epochs;

parfor copy = 1:copies
a = alist(:,:,copy);
b = blist(:,:,copy);
w = wlist(:,:,copy);
[vd,hd,vhd,vm,hm,vhm] = gibbs(a,b,w,k,vdata,smooth);
grada = lambda*(vd - vm); 
gradb = lambda*(hd - hm); 
gradw = lambda*(vhd - vhm);
a = a + grada; alist(:,:,copy) = a;
b = b + gradb; blist(:,:,copy) = b;
w = w + gradw; wlist(:,:,copy) = w;
if ~mod(ep,interval)
    [~,KL] = get_KL(vdata, a, b, w);
    [v0,h0] = brute(a,b,w);
    frus = get_frus(a,b,w,v0,h0);
    KL_list(copy, c_monitor) = KL;
    frus_list(copy, c_monitor) = frus;
end
end

end

% tot_list = cat(3,KL_list,frus_list);
% save('data.mat','tot_list');
% 
% data = load('data.mat');
% totlist = data.tot_list;
% KL_list = tot_list(:,:,1); frus_list = tot_list(:,:,2);

myplot(1:length(KL_list),cat(3,KL_list, frus_list),[40 50 60],false,false);