function A = trajectory_param(time)
global dofs
traj_wf = 0.2*pi; % 基频
traj_order = 5;   % 阶数 
numParam=traj_order*2+1; % 总共多少个参数

% 参数顺序按照q0，a1，b1，a2...a5，b5的顺序
A = zeros(3*dofs,numParam*dofs);
for dof=1:dofs
   m = numParam*(dof-1); 
   base = 3*(dof-1);
   A( base+1, m+1) = 1;
   for n=1:traj_order
       A( base+1, m + 2*n ) = sin(traj_wf*n*time) / (traj_wf * n);
       A( base+1, m + 2*n+1 ) = -cos(traj_wf*n*time) / (traj_wf * n);
       A( base+2, m + 2*n ) = cos(traj_wf*n*time);
       A( base+2, m + 2*n+1 ) = sin(traj_wf*n*time);
       A( base+3, m + 2*n ) = -traj_wf*n*sin(traj_wf*n*time);
       A( base+3, m + 2*n+1 ) = traj_wf*n*cos(traj_wf*n*time);
   end
end
end