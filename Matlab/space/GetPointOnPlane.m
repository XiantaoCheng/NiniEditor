%% 20230312
%% from 文档\数学问题\空间投影.ftxt
%{
地址::Matlab\space\GetPointOnPlane.m
+[保存M函数](,GetPointOnPlane)

保存:...
%}


function [X,Y,Z]=GetPointOnPlane(x,y,pt1,Eulers1,pt0,Eulers0,S)
% center=pt+siz/2;
% x=x0-center(1);
% y=y0-center(2);
% [Eulers,r0,S]=camera_from_photo(x,y,1);


% abc=[0,0,1];
% pt0=[0,0,0];


[Xu,Yu,Zu]=Euler_frame(Eulers0(1),Eulers0(2),Eulers0(3));
T=[Xu',Yu',Zu'];

[~,~,abc]=Euler_frame(Eulers1(1),Eulers1(2),Eulers1(3));
abc1=abc*T;
pt01=(pt1-pt0)*T;
p1=x/S;
q1=y/S;


Z1=sum(abc1.*pt01)./(abc1(1)*p1+abc1(2)*q1+abc1(3));
X1=p1.*Z1;
Y1=q1.*Z1;


X=Xu(1)*X1+Yu(1)*Y1+Zu(1)*Z1;
Y=Xu(2)*X1+Yu(2)*Y1+Zu(2)*Z1;
Z=Xu(3)*X1+Yu(3)*Y1+Zu(3)*Z1;


X=X+pt0(1);
Y=Y+pt0(2);
Z=Z+pt0(3);


end


 

