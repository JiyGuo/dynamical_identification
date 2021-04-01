% 数据预处理
clear;clc;close all;
begin = 60000;
% 加载数据
prefix = '20210331_2';
filename = '\joint.mat';
file = [prefix,filename];
load(file);

joint = ans(2:end,6000:end);
for i=1:6
    vel(i,:) = diff2(joint(i,:)).*1000;
end

for i=1:6
    filt_q(i,:) = smooth(ans(i+1,7070:end),50)';
end
% filt_q = ans(2:end,7070:end);
clear ans;

filename = '\torque.mat';
file = [prefix,filename];
load(file);
for i=1:6
    filt_t(i,:) = smooth(ans(i+1,7070:end),50)';
end
clear ans;

clear file;
clear filename;
clear i;
clear prefix;
save('data\20210331_2.mat')

