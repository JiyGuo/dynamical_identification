function Optimaltrajectory_plot(opt_x) 
totelTime = 10;
traj_Ts=0.001;%采样周期
traj_n=totelTime/traj_Ts;%采样个数
opt_q = zeros(traj_n+1,6);
opt_qd = zeros(traj_n+1,6);
opt_qdd = zeros(traj_n+1,6);

for k=1:1:traj_n+1
[opt_q(k,:),opt_qd(k,:),opt_qdd(k,:)]=trajectory_function( opt_x,(k-1)*traj_Ts);
end

xx=(1:1:traj_n+1)*0.1;
figure(1)
plot(xx,opt_q(:,1),'r',xx,opt_q(:,2),'c',xx,opt_q(:,3),'y',xx,opt_q(:,4),'g',xx,opt_q(:,5),'b',xx,opt_q(:,6),'m');
title('q');
legend('q1','q2','q3','q4','q5','q6');
figure(2)
plot(xx,opt_qd(:,1),'r',xx,opt_qd(:,2),'c',xx,opt_qd(:,3),'y',xx,opt_qd(:,4),'g',xx,opt_qd(:,5),'b',xx,opt_qd(:,6),'m');
title('qd');
legend('qd1','qd2','qd3','qd4','qd5','qd6');
figure(3)
plot(xx,opt_qdd(:,1),'r',xx,opt_qdd(:,2),'c',xx,opt_qdd(:,3),'y',xx,opt_qdd(:,4),'g',xx,opt_qdd(:,5),'b',xx,opt_qdd(:,6),'m');
title('qdd');
legend('qdd1','qdd2','qdd3','qdd4','qdd5','qdd6');
end