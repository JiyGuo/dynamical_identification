% 数据预处理
clear;clc;close all;
% 加载数据
prefix = '20210325_1';
filename = '\filt_qdd.mat';
file = [prefix,filename];
load(file);
filt_qdd = ans(2:end,:);
clear ans;

filename = '\filt_qd.mat';
file = [prefix,filename];
load(file);
filt_qd = ans(2:end,:);
clear ans;

filename = '\filt_q.mat';
file = [prefix,filename];
load(file);
filt_q = ans(2:end,:);
clear ans;

filename = '\torque.mat';
file = [prefix,filename];
load(file);
for i=1:6
    filt_t(i,:) = smooth(ans(i+1,:),50)';
end
clear ans;

clear file;
clear filename;
clear i;
clear prefix;
save('data\20210325_1.mat')

