function [ q,qd,qdd ] = trajectory_function(x,time)
traj_wf = 0.2*pi; % ��Ƶ
% global dofs
dofs = 6;          % ���ɶ�
traj_order = 5;   % ���� 

q=zeros(dofs,1);
qd=zeros(dofs,1);
qdd=zeros(dofs,1);
numParam=traj_order*2+1; % �ܹ����ٸ�����
% ����˳����q0��a1��b1��a2...a5��b5��˳��

for d=1:dofs
   m=numParam*(d-1);
   q(d)=x(m+1);
   for n=1:traj_order
       q(d)= q(d)+((x(m + 2*n) / (traj_wf * n))*sin(traj_wf*n*time) - (x(m + 2*n+1) / (traj_wf * n))*cos(traj_wf*n*time));
       qd(d) = qd(d)+(x(m + 2*n) * cos(traj_wf*n*time)+x(m + 2*n+1)*sin(traj_wf*n*time));
       qdd(d) = qdd(d)+traj_wf*n*(-x(m + 2*n)*sin(traj_wf*n*time)+x(m + 2*n+1)*cos(traj_wf*n*time));
   end
end
end


