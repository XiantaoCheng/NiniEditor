%% 20230204
%% from 文档\数学问题\三维旋转.ftxt
%{
+[M函数](,rotation_Eulers)

地址::Matlab\space\rotation_Eulers.m
+[保存M函数](,rotation_Eulers)
%}


function Eulers=rotation_Eulers(Eulers,zu,theta)
[X0,Y0,Z0]=Euler_frame(Eulers(1),Eulers(2),Eulers(3));
x=[X0(1),Y0(1),Z0(1)];
y=[X0(2),Y0(2),Z0(2)];
z=[X0(3),Y0(3),Z0(3)];

[x,y,z]=rotation_3D(x,y,z,zu,theta);

X=[x(1),y(1),z(1)];
Y=[x(2),y(2),z(2)];
Z=[x(3),y(3),z(3)];

Eulers=frame2Eulers(X,Y,Z);

end


