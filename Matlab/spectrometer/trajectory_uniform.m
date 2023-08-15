%% 20220415
%% from 文档\物理问题\电子能谱.ftxt
%{
+[M函数](,trajectory_uniform)

地址::Matlab\spectrometer\trajectory_uniform.m
+[保存M函数](,trajectory_uniform)

测试函数(M函数):...
%}



function [x0,y0,R,beta,x_1m,y_1m,x_2m,y_2m] = trajectory_uniform(xe,ye,theta_e,E,pos_m,siz_m,B,pos_p,theta_p)

physics_constant;

%{
% electron
xe=0;
ye=0;
theta_e=20;
E=10e9*e;

% magnet
pos_m=[5,0];
siz_m=[5,5];
B=1.2;

% IP
pos_p=[40,0];
theta_p=-20;
%}


x_1m=pos_m(1)-siz_m(1)/2;
x_2m=pos_m(1)+siz_m(1)/2;
Dm=siz_m(1);

%ye
%tan(theta_e)
%(x_1m-xe)

y_1m=ye+tan(theta_e).*(x_1m-xe);

R=sqrt(E.^2/c^2-me^2*c^2)/e/B;
beta=asin(sin(theta_e)-Dm./R);
y_2m=y_1m+R.*(cos(beta)-cos(theta_e));

D1=pos_p(1)*sin(theta_p+pi/2)-pos_p(2)*cos(theta_p+pi/2);
Dx1=cos(theta_p+pi/2);
Dy1=sin(theta_p+pi/2);

D2=x_2m.*sin(beta)-y_2m.*cos(beta);
Dx2=cos(beta);
Dy2=sin(beta);

x0=(D1*Dx2-D2*Dx1)./(Dy1*Dx2-Dy2*Dx1);
y0=(D1*Dy2-D2*Dy1)./(Dy1*Dx2-Dy2*Dx1);


%{
% Trajectory
angle=linspace(theta_e,beta,100);
x_m=R*(sin(theta_e)-sin(angle))+x_1m;
y_m=R*(cos(angle)-cos(theta_e))+y_1m;
x=[xe,x_1m,x_m,x_2m,x_0];
y=[ye,y_1m,y_m,y_2m,y_0];
plot(x,y,'.-',x_m,y_m)
%}

end

%{
+[M函数](,轨迹)
%}

