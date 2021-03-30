function [fai] = observationMatrix(q,qd,qdd,dof,param_min_num)
numParam = 13;
fai = zeros(dof,param_min_num);
P = zeros(numParam * dof,1);
g = 9.81;

%第一个关节单独处理
idx = [6,11,12];
col = 0;
for i=1:3
    col = col+1;
    P(idx(i)) = 1;
    fai(:,col) = NewtonEular(g,q, qd, qdd ,P);
    P(idx(i)) = 0;
end

%其他关节
for i=2:dof
    base = numParam*(i-1);
    for j = 1:13
        if j==4 || j==9 || j==10
            continue;
        end
        if i==2 && j==13
            continue;
        end
        col = col+1;
        P(base+j) = 1;
        fai(:,col) = NewtonEular(g,q, qd, qdd ,P);
        P(base+j) = 0;
    end
end
end

