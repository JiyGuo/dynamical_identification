function [ y ] = parameters(theta, thetad, thetadd )
%初始化条件
H = zeros(3,10,6);
A = zeros(3,10,6);
Yf = zeros(3,60,6);
Y = zeros(3,60,6);
y = zeros(6,60);

[ W, ~, Ang_acc, acc ] = velocity_iteration_parameters(  theta, thetad, thetadd );
[ T ] = f_kinematics(theta);

for i=1:6
    
    H(:,7:9,i) = S_w(Ang_acc(:,i+1)) + S_w(W(:,i+1)) * S_w(W(:,i+1));
    H(:,10,i) = acc(:,i+1);
    
    A(:,1:6,i) = K_w(Ang_acc(:,i+1)) + S_w(W(:,i+1)) * K_w(W(:,i+1));
    A(:,7:9,i) = -S_w(acc(:,i+1));
end

Yf(:,51:60,6) =  H(:,:,6);
Y(:,51:60,6) =  A(:,:,6);
y(6,:) = Y(3,:,6);

for i=5:-1:1
    Yf(:,(10*i-9):(10*i),i) = H(:,:,i);
    Yf(:,:,i) = Yf(:,:,i) + T(1:3,1:3,i+1) * Yf(:,:,i+1);
    
    Y(:,(10*i-9):(10*i),i) = A(:,:,i);
    Y(:,:,i) = Y(:,:,i) + T(1:3,1:3,i+1) * Y(:,:,i+1) + S_w(T(1:3,4,i+1)) * T(1:3,1:3,i+1) * Yf(:,:,i+1);
    
    y(i,:) = Y(3,:,i);
end


end

