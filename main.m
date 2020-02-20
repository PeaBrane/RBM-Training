%%%%%   Initialization   %%%%%

addpath(genpath('.'));
clear;
rng(0);

%%%%% Network Parameters %%%%%

n = 9;
m = 12;
nd = 1;
w_ini = 0.01;
copies = 10000;

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

% alist = w_ini*(2*rand([1 n copies]));
% blist = w_ini*(2*rand([1 m copies]));
% wlist = w_ini*(2*rand([n m copies]));

%%%%% Data Set %%%%%

% [ind,vdata] = data_sb(n,5);

%%%%% Monitoring Lists %%%%%

% KL_list = zeros( copies, floor(epochs/interval) );
% frus_list = zeros( copies, floor(epochs/interval) );

%%%%% Update %%%%%

% mkdir('data');
% parfor copy = 1:copies
% 
% a = w_ini*(2*rand([1 n]));
% b = w_ini*(2*rand([1 m]));
% w = w_ini*(2*rand([n m]));
% KL_list = zeros( 1, floor(epochs/interval) );
% frus_list = zeros( 1, floor(epochs/interval) );
% [ind,vdata] = data_sb(n,5);
% 
% c_monitor = 0;
% for ep = 1:epochs
%     
% if ~mod(ep,interval)
%     c_monitor = c_monitor + 1;
% end
% % mydot(ep,epochs);
%     
% lambda = lmax - (lmax - lmin)*ep/epochs;
% 
% [vd,hd,vhd,vm,hm,vhm] = gibbs(a,b,w,k,vdata,smooth);
% grada = lambda*(vd - vm); 
% gradb = lambda*(hd - hm); 
% gradw = lambda*(vhd - vhm);
% a = a + grada;
% b = b + gradb;
% w = w + gradw;
% if ~mod(ep,interval)
%     [~,KL] = get_KL(vdata, a, b, w);
%     [v0,h0] = brute(a,b,w);
%     frus = get_frus(a,b,w,v0,h0);
%     KL_list(c_monitor) = KL;
%     frus_list(c_monitor) = frus;
% end
% end
% 
% totlist = cat(3,KL_list,frus_list);
% parsave(strcat('data/instance_',num2str(copy),'.mat'),totlist);
% 
% end

KL_list = zeros(copies,floor(epochs/interval));
frus_list = zeros(copies,floor(epochs/interval));
counter = 0;
for copy = 1:copies
   
    counter = counter + 1;
    fn = strcat('data/instance_',num2str(copy),'.mat');
    data = load(fn);
    data = data.variable;
    KL_list(copy,:) = data(1,:,1);
    frus_list(copy,:) = data(1,:,2);
    
end

% tot_list = cat(3,KL_list,frus_list);
% save('data.mat','tot_list');
% 
% data = load('data.mat');
% totlist = data.tot_list;
% KL_list = totlist(:,:,1); frus_list = totlist(:,:,2);

myplot(1:size(KL_list,2),cat(3,KL_list, frus_list),[30 50 70],false,false);