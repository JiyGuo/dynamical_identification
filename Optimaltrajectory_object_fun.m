function f=Optimaltrajectory_object_fun(x) 
global dofs
param_min_num = 52;
global traj_n
global traj_Ts

ww=zeros((traj_n+1)*dofs,param_min_num);

for k=1:1:traj_n+1
    [q,qd,qdd]=trajectory_function( x,(k-1)*traj_Ts);
    row1=(1+(k-1)*dofs);
    row2=(6+(k-1)*dofs);
    ww(row1:row2,:) = observationMatrix(q,qd,qdd,dofs,param_min_num);
end

f=cond(ww);

end