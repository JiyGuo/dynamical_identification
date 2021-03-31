clear;
clc;
close all;
global traj_n
global traj_Ts
global dofs
dofs=6;

%有约束非线性最优化问题
totelTime = 10;

traj_Ts=0.01;%采样周期
traj_n=totelTime/traj_Ts;%采样个数

AA = [];
bb = [];
% 关节角度、角速度、角加速度限制
b=[2.8; 6.98; 26.17;  0.95; 5.68; 26.17;  0.70; 7.15; 26.17;  2.80; 7.85; 30.54;  1.50; 7.15; 26.17;  6.20; 11.17; 43.63;
   2.8; 6.98; 26.17;  1.30; 5.68; 26.17;  2.50; 7.15; 26.17;  2.80; 7.85; 30.54;  1.50; 7.15; 26.17;  6.20; 11.17; 43.63;];

constraint_Ts=0.25;%约束周期
constraint_n=totelTime/constraint_Ts;%约束个数
% 不等式约束
for k=1:1:constraint_n-1
    A = trajectory_param(k*constraint_Ts);  
    AA=[AA;A;-A];
    bb=[bb;b];
end

% 等式约束

A0 = trajectory_param(0);
Aeq = A0;
Aeq(1:3:18,:) = [];
beq = zeros(12,1);

%求解
for i = 1:1
    opt_x0 = 1.05 * rand(66,1); %初解
    [opt_x(:,i),opt_fval(i)] = fmincon(@Optimaltrajectory_object_fun,opt_x0,AA,bb,Aeq,beq);
    if opt_fval(i)<10.0
        break;
    end
end

%绘图
Optimaltrajectory_plot(opt_x(:,end));
