%% 20230313
%% from 文档\数学问题\空间投影.ftxt
%{
地址::Matlab\space\getPointOnLine.m
+[保存M函数](,getPointOnLine)

保存:...
测试:...
%}


function [X,Y,Z]=getPointOnLine(x,y,pt1,k1,pt0,Eulers0,S)

[Xu,Yu,Zu]=Euler_frame(Eulers0(1),Eulers0(2),Eulers0(3));
T=[Xu',Yu',Zu'];
k=k1*T;
Dp=pt1-pt0;
x0=sum(Dp.*Xu);
y0=sum(Dp.*Yu);
z0=sum(Dp.*Zu);

p=x/S;
q=y/S;

p0=k(1)/k(3);
q0=k(2)/k(3);
kp=x0-z0*k(1)/k(3);
kq=y0-z0*k(2)/k(3);
k_n=sqrt(kp.^2+kq.^2);

p1=p0+((p-p0)*kp+(q-q0)*kq)*kp/k_n^2;
% p1=p;
% q1=q;

t1=(x0-p1*z0)./(k(3)*p1-k(1));
% t1=(y0-q1*z0)./(k(3)*q1-k(2));
x1=k(1)*t1+x0;
y1=k(2)*t1+y0;
z1=k(3)*t1+z0;


X=Xu(1)*x1+Yu(1)*y1+Zu(1)*z1;
Y=Xu(2)*x1+Yu(2)*y1+Zu(2)*z1;
Z=Xu(3)*x1+Yu(3)*y1+Zu(3)*z1;


X=X+pt0(1);
Y=Y+pt0(2);
Z=Z+pt0(3);


end


 

