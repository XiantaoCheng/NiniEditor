%% 20221229
%% from 文档\物理问题\电子能谱.ftxt
%{
地址::Matlab\spectrometer\trajectory_ft.m
+[保存M函数](,trajectory_ft)

保存:...
%}

function [E,y_f]=trajectory_ft(x_s,y_s,theta,x_m,D,B,x_i,y_i,x_f)
physics_constant;

x_m1=x_m-D/2;
x_m2=x_m+D/2;


R=10*D;
y_m1=y_s-tan(theta).*(x_s-x_m1);
beta=asin(sin(theta)-D./R);

for i=1:100

    Delta=R.*(cos(beta)-cos(theta));
    y_m2=y_m1+Delta;
    beta=(1)./(2).*(atan((y_m2-y_i)./(x_m2-x_i))+asin(sin(theta)-(D)./(R)));
    R=(D)./(sin(theta)-sin(beta));

end

E=sqrt(R.^2*B^2*c^2*e^2+me^2*c^4);
y_f=y_i+tan(beta).*(x_f-x_i);

end


%{
+[M函数](,验证公式)
%}

