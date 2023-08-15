%% 20230110
%% from 文档\物理问题\电透镜.ftxt
%{
地址::Matlab\SEM\tm_traj.m
+[保存M函数](,tm_traj)
%}


% transfer matrix method: calculate trajectory (position, voltage, initial
% position and angle)
function [r_all, angle_all] = tm_traj(x_all, V_all, vec0)
    %% transfer matrix calculation
    E_all = zeros(length(x_all),2);
    for i = 1:length(x_all)-1
        E_all(i+1) = (V_all(i+1)-V_all(i))/(x_all(i+1)-x_all(i));
    end
    
    Ua = zeros([2,2,length(x_all)-1]);
    Ub = zeros([2,2,length(x_all)-1]);
    
    for i = 1:length(x_all)-1
        Ua(:,:,i) = tm_dflt(E_all(i),E_all(i+1),V_all(i));
        Ub(:,:,i) = tm_drift(V_all(i),V_all(i+1),x_all(i+1)-x_all(i));
    end
    
    %% vector calculation
    vec = zeros(2,length(x_all));
    vec(:,1) = vec0; % [pos; angle*sqrt(V)]
    for i = 1:length(x_all)-1
        vec(:,i+1) = Ub(:,:,i)*Ua(:,:,i)*vec(:,i);
    end
    
    r_all = vec(1,:);
    angle_all = vec(2,:)./sqrt(V_all);
end

