%%%%%   Initialization   %%%%%

addpath(genpath('..'));
clear;
rng(0);

%%%%% Network Parameters %%%%%

n = 9;
m = 18;
nd = 5; % size of data set
w_ini = 0.01; % initial weight magnitudes
copies = 50; % size of ensemble

%%%%% Training Parameters %%%%

epochs = 10000;

%%%%% CD-k Parameters %%%%%

lmax = 0.5*10^-1; % maximum learning rate
lmin = 0.5*10^-3; % minimum learning rate
k = 1; % number of reconstruction iterations
smooth = true; % if true, reconstruct probabilities in last iteration
learn = linspace(lmax,lmin,epochs);

%%%%% Plot Parameters %%%%%

interval = 100; % KL is computed once an interval

%%%%% Network Parameter Initialization %%%%%

alist = w_ini*(2*rand([1 n copies])); % visible biases
blist = w_ini*(2*rand([1 m copies])); % hidden biases
wlist = w_ini*(2*rand([n m copies])); % weights

%%%%% Data Set %%%%%

[ind,vdata] = data_sb(n,5);

%%%%% Monitoring Lists %%%%%

KL_list = zeros( copies, floor(epochs/interval) );

%%%%% Update %%%%%


c_monitor = 0;
for ep = 1:epochs
    
if ~mod(ep,interval)
    c_monitor = c_monitor + 1;
    fprintf('.');
end
    
l = learn(ep);

for copy = 1:copies
a = alist(:,:,copy); b = blist(:,:,copy); w = wlist(:,:,copy);
[vd,hd,vhd,vm,hm,vhm] = gibbs(a,b,w,k,vdata,smooth);
grada = l*(vd - vm); 
gradb = l*(hd - hm); 
gradw = l*(vhd - vhm);
a = a + grada;
b = b + gradb;
w = w + gradw;
alist(:,:,copy) = a; blist(:,:,copy) = b; wlist(:,:,copy) = w;
if ~mod(ep,interval)
    [~,KL] = get_KL(vdata, a, b, w);
    KL_list(copy,c_monitor) = KL;
end
end

end

myplot(1:size(KL_list,2),KL_list,[10 50 90],false,false);