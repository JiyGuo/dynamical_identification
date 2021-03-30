close all;
clear;clc;
%%逆动力学
theta1=[0 0 0 0 0 0];    %机器人伸直且垂直
% robot.plot(theta1);  %SerialLink类函数,显示机器人图像
theta2=[-pi/7 pi/2 -pi/6 pi/5 pi/2 pi/3];
t=[0:0.01:2];
[q,qd,qdd]=jtraj(theta1,theta2,t);
for i=1:size(q,1)
    torque(i,:) = NewtonEular(9.81, q(i,:), qd(i,:), qdd(i,:) );
    torque2(i,:) = Force_iteration( q(i,:), qd(i,:), qdd(i,:) );
end
plot(torque-torque2)


