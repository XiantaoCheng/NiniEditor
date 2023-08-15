%% 20221228
%% from 文档\物理问题\电子能谱.ftxt
%{
地址::Matlab\spectrometer\trajectory_fs.m
+[保存M函数](,trajectory_fs)
%}

function [E,theta,R,y_m1,y_m2,beta]=trajectory_fs(x_s,y_s,x_m,D,B,x_f,y_f,x_i,y_i)
physics_constant;

theta=0;
x_m1=x_m-D/2;
x_m2=x_m+D/2;


beta=atan((y_i-y_f)./(x_i-x_f));
y_m2=y_i-tan(beta).*(x_i-x_m2);

R=10*D;
theta=asin(D./R+sin(beta));
for i=1:100
    Delta=R.*(cos(beta)-cos(theta));
    y_m1=y_m2-Delta;
    theta=(atan((y_m1-y_s)./(x_m1-x_s))+asin(D./R+sin(beta)))/2;
    R=(D)./(sin(theta)-sin(beta));
end

E=sqrt(R.^2*B^2*c^2*e^2+me^2*c^4);
end


%{
R
beta
theta
+[M函数](,验证公式)
%}

