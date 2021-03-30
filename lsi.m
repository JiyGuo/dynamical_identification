% 最小二乘辨识
clear;clc;close all;
% 加载数据
load('filt_qdd.mat');
load('filt_qd.mat');
load('filt_q.mat');
load('filt_t.mat');

duration = 15;
dt = 0.001;
start = 15/0.001;

dofs = 6;
param_min_num = 52;

traj_n = duration / dt;

ww=zeros((traj_n+1)*dofs,param_min_num);
row1=1;
row2=6;
for k=0:1:traj_n
    q = filt_q(:,start + k);
    qd = filt_qd(:,start + k);
    qdd = filt_qdd(:,start + k);
    phi(row1:row2,:) = observationMatrix(q,qd,qdd,dofs,param_min_num);
    tau(row1:row2,1) = filt_t(:,start + k);
    row1 = row1+6;
    row2 = row2+6;
end

para = pinv(phi) * tau;
cal_t = phi*para;
error = tau-cal_t;




for i = 1:6
   dep_error(:,i) = error(i:6:end); 
end
for i = 1:6
   dep_tau(:,i) = tau(i:6:end); 
end
for i = 1:6
   dep_cal_t(:,i) = cal_t(i:6:end); 
end
plot(dep_error(:,1))
figure
plot(dep_tau(:,2))
hold on;
plot(dep_cal_t(:,2))



