%% 20221228
%% from 文档\伊甸园\星辰.ftxt
%{
+[保存M函数](,trajectory_XY)
地址::Matlab\spectrometer\trajectory_XY.m
%}



function [X,Y]=trajectory_XY(xe,ye,theta_e,x0,y0,r,beta,x_1m,y_1m,x_2m,y_2m)

% Trajectory
X_e=reshape(xe,numel(xe),1);
Y_e=reshape(ye,numel(ye),1);
X_1m=x_1m*ones(numel(y_1m),1);
Y_1m=reshape(y_1m,numel(y_1m),1);
X_2m=x_2m*ones(numel(y_2m),1);
Y_2m=reshape(y_2m,numel(y_2m),1);
X0=reshape(x0,numel(x0),1);
Y0=reshape(y0,numel(y0),1);


if numel(r)>1
    R=reshape(r,numel(r),1);
else
    R=r*ones(numel(y_1m),1);
end


angle=[];
for i=1:length(beta)
    angle(i,:)=linspace(theta_e(i),beta(i),10);
end



X_m=R.*(sin(theta_e')-sin(angle))+x_1m';
Y_m=R.*(cos(angle)-cos(theta_e'))+y_1m';



X=[X_e,X_1m,X_m,X_2m,X0];
Y=[Y_e,Y_1m,Y_m,Y_2m,Y0];

end

