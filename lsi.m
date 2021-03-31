% 最小二乘辨识
clear;clc;close all;
% 加载数据
data(1) = load('data\20210331_1.mat');
data(2) = load('data\20210331_2.mat');
data(3) = load('data\20210329_2.mat');
data(4) = load('data\20210329_3.mat');
data(5) = load('data\20210329_4.mat');
data(6) = load('data\20210329_1.mat');


dofs = 6;
param_min_num = 52;
duration = 10;
dt = 0.001;
traj_n = duration / dt;
ww=zeros((traj_n+1)*dofs,param_min_num);
row1=1;
row2=6;

startTime = [10,10,25,20,15,40];
% startTime = [15,35,25,20,15];

for i=1:length(data)
	start = startTime(i)/dt;
    for k=0:2:traj_n
        q = data(i).filt_q(:,start + k);
        qd = data(i).filt_qd(:,start + k);
        qdd = data(i).filt_qdd(:,start + k);
        tau(row1:row2,1) = data(i).filt_t(:,start + k-50);
        phi(row1:row2,:) = observationMatrix(q,qd,qdd,dofs,param_min_num);
        row1 = row1+6;
        row2 = row2+6;
    end 
end

para = pinv(phi) * tau;
