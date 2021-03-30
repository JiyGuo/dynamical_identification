function [ torque ]= NewtonEular( g,q, qd, qdd ,P)
%初始化条件

a = [0,0.04,0.275,0.025, 0, 0];
d = [0.0, 0.0, 0.0, 0.28, 0.0, 0.0];
alfa = [0, -1.570796327, 0, -1.570796327, 1.570796327, -1.570796327];
theta = [0, -1.570796327, 0, 0, 0, 0];
q = q+theta;

dof = 6;
numParam = 13;

m = zeros(1,dof);
I_para = zeros(6,dof);
P_c = zeros(3,dof);
I_drive = zeros(1,dof);
fc = zeros(1,dof);
fv = zeros(1,dof);
for i = 1:dof
    tmp = numParam*(i-1);
    I_para(:,i) = P(tmp+1:tmp+6);
    P_c(:,i) = P(tmp+7:tmp+9);
    m(i) = P(tmp+10);
    fc(i) = P(tmp+11);
    fv(i) = P(tmp+12);
    I_drive(i) = P(tmp+13);
end

% m = [5.6431, 5.0478, 5.7542, 3.0870, 2.0459, 2.6317 ];
% 
% I_c(:,:,1) = [0.1183, -0.0001, 0.0001; -0.0001, 0.1182, 0.0001; 0.0001, 0.0001, 0.0140];
% I_c(:,:,2) = [0.0723, 0.0000, -0.0051; 0.0000, 0.0784, 0.0000; -0.0051, 0.0000, 0.0169];
% I_c(:,:,3) = [0.4263, 0.0000, -0.0072; 0.0000, 0.4334, 0.0001; -0.0072, 0.0001, 0.0191];
% I_c(:,:,4) = [0.0821, 0.0000, -0.0314; 0.0000, 0.1257, 0.0001; -0.0314, 0.0001, 0.0451];
% I_c(:,:,5) = [0.0235, 0.0000, -0.0002; 0.0000, 0.0253, 0.0000; -0.0002, 0.0000, 0.0045];
% I_c(:,:,6) = [0.0684, 0.0000, 0.0001; 0.0000, 0.0696, -0.0001; 0.0001, -0.0001, 0.0047];
% 
% P_c(1,:) = [0.0002, 0.0002, 0.1264];
% P_c(2,:) = [-0.0062, 0.0001, 0.1080];
% P_c(3,:) = [-0.0131, 0.0001, 0.2402];
% P_c(4,:) = [-0.0850, 0.0003, 0.1540];
% P_c(5,:) = [0.0001, 0.0002, 0.0982];
% P_c(6,:) = [-0.0111, -0.0003, 0.1366];

% %惯性矩在连杆坐标系
% I_p = zeros(3,3,6);
% I_para = zeros(6,1,6);
% I = [1 0 0;
%      0 1 0;
%      0 0 1];
% for i=1:6
%     I_p(:,:,i) = I_c(:,:,i) + m(i) * (P_c(i,:) * P_c(i,:).' * I - P_c(i,:).' * P_c(i,:));
%     I_para(1,1,i) = I_p(1,1,i);
%     I_para(2,1,i) = -I_p(1,2,i);
%     I_para(3,1,i) = -I_p(1,3,i);
%     I_para(4,1,i) = I_p(2,2,i);
%     I_para(5,1,i) = -I_p(2,3,i);
%     I_para(6,1,i) = I_p(3,3,i);
% end


f = zeros(3,7);
n = zeros(3,7);
F = zeros(3,6);
N = zeros(3,6);
torque = zeros(1,6);
Z_axi = [0
         0
         1];
 
T = zeros(4,4,7);
T(:,:,7) = eye(4);
for i = 1:6
 T(:,:,i) = [cos(q(i)) -sin(q(i)) 0 a(i);
       sin(q(i))*cos(alfa(i)) cos(q(i))*cos(alfa(i)) -sin(alfa(i)) -d(i)*sin(alfa(i));
       sin(q(i))*sin(alfa(i)) cos(q(i))*sin(alfa(i)) cos(alfa(i)) d(i)*cos(alfa(i));
       0 0 0 1]; 
end

% 速度的正向迭代
W = zeros(3,7);
Ang_acc = zeros(3,7);
% acc_c = zeros(3,6);
acc = zeros(3,7);
acc(:,1) = [0;0;g];
for i=1:6
    i_iadd1_T = T(:,:,i);
    i_iadd1_R = i_iadd1_T(1:3,1:3);
    i_P_iadd1 = i_iadd1_T(1:3,4);
    iadd1_i_R = i_iadd1_R.';
    W(:,i+1) = iadd1_i_R * W(:,i) + qd(i) .* Z_axi;    
    Ang_acc(:,i+1) = iadd1_i_R * Ang_acc(:,i) +  cross(iadd1_i_R *W(:,i), qd(i) * Z_axi) + qdd(i) * Z_axi;
    acc(:,i+1) = iadd1_i_R * (acc(:,i) + cross(Ang_acc(:,i), i_P_iadd1) + cross(W(:,i), cross(W(:,i), i_P_iadd1)));
%     acc_c(:,i) = acc(:,i+1) + cross( Ang_acc(:,i+1), P_c(:,i)) + cross(W(:,i+1), cross(W(:,i+1),  P_c(:,i)));
    F(:,i) = m(i) * acc(:,i+1) + cross( Ang_acc(:,i+1), P_c(:,i)) + cross(W(:,i+1), cross(W(:,i+1),  P_c(:,i)));
    
end

 
% 力的反向迭代
for i=6:-1:1
    i_iadd1_T = T(:,:,i+1);
    i_iadd1_R = i_iadd1_T(1:3,1:3);
    i_P_iadd1 = i_iadd1_T(1:3,4); 

%     N(:,i) = K_w(Ang_acc(:,i+1)) * I_para(:,i) + S_w(W(:,i+1)) * (K_w(W(:,i+1)) * I_para(:,i)) - S_w(acc(:,i+1)) * (m(i) * P_c(:,i));
    N(:,i) = K_w(Ang_acc(:,i+1)) * I_para(:,i) + S_w(W(:,i+1)) * (K_w(W(:,i+1)) * I_para(:,i)) - S_w(acc(:,i+1)) * ( P_c(:,i));
    
    f(:,i) = i_iadd1_R * f(:,i+1) + F(:,i);
    n(:,i) = i_iadd1_R * n(:,i+1) + N(:,i) + S_w(i_P_iadd1) * (i_iadd1_R * f(:,i+1)) ;
    n(3,i) = n(3,i) + I_drive(i)*qdd(i) + fc(i)*sign(qd(i)) + fv(i)*qd(i);
    
    torque(i) = n(3,i);
end
end

