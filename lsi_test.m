only_plot = false;
close all;
if ~only_plot
    % 最小二乘辨识
    clear;clc;
    % 加载数据
    data = load('data\20210329_5.mat');
    load('data\para_20210331_5.mat');


    duration = 10;
    dt = 0.001;
    start = 10/0.001;

    dofs = 6;
    param_min_num = 52;

    traj_n = duration / dt;

    ww=zeros((traj_n+1)*dofs,param_min_num);
    row1=1;
    row2=6;
    for k=0:20:traj_n
        q = data.filt_q(:,start + k);
        qd = data.filt_qd(:,start + k);
        qdd = data.filt_qdd(:,start + k);
        phi(row1:row2,:) = observationMatrix(q,qd,qdd,dofs,param_min_num);
        tau(row1:row2,1) = data.filt_t(:,start + k);
        row1 = row1+6;
        row2 = row2+6;
    end

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
    
end

for i=1:6
%     figure;
	subplot(6,2,2*(i-1)+1);
    plot(dep_error(:,i)/1000)
    title(['误差：',num2str(i),'关节']);
    ylabel('Torque/N.m');
	subplot(6,2,2*(i-1)+2);

    plot(dep_tau(:,i)/1000)
    hold on;
    plot(dep_cal_t(:,i)/1000)
    title(['对比：',num2str(i),'关节']);
    ylabel('Torque/N.m');
    legend('测量值','拟合值')
end


