%% 20230204
%% from 文档\S应用\三维建模.ftxt
%{
+[保存M函数](,transform_3D_frame)
地址::Matlab\space\transform_3D_frame.m

测试:...
+[M函数](,测试)

版本1:...
(这一版有问题, Euler_frame输出的XYZ要做一些处理)
%}

function [pt2,Eulers2]=transform_3D_frame(pt,alpha,beta,gamma,pt1,Eulers1)

[x,y,z]=transform_3D(pt,alpha,beta,gamma,pt1(1),pt1(2),pt1(3));
pt2=[x,y,z];

[X,Y,Z]=Euler_frame(Eulers1(1),Eulers1(2),Eulers1(3));
[vX,vY,vZ]=Euler_frame(alpha,beta,gamma);

T=[vX;vY;vZ];
P0=[X;Y;Z];
P=P0*T;

X2=P(1,:);
Y2=P(2,:);
Z2=P(3,:);
Eulers2=real(frame2Eulers(X2,Y2,Z2));

end

%{
+[保存M函数](,transform_3D_frame)
+[M函数](,测试)
%}

