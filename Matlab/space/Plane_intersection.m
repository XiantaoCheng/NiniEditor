%% 20230729
%% from 文档\数学问题\直线交点.ftxt
%{
地址::Matlab/space/Plane_intersection.m
+[保存M函数](,Plane_intersection)
%}
function [x_B,y_B,z_B,t_B]=Plane_intersection(x_A,y_A,z_A,v1_x,v1_y,v1_z,r0,Eulers)
% r0=[0,0,0];

alpha=Eulers(1);
beta=Eulers(2);
gamma=Eulers(3);

s=[sind(alpha)*sind(beta), -cosd(alpha)*sind(beta), cosd(beta)];
A=s(1)*v1_x+s(2)*v1_y+s(3)*v1_z;

t_B=(s(1)*(r0(1)-x_A)+s(2)*(r0(2)-y_A)+s(3)*(r0(3)-z_A))./A;
x_B=v1_x.*t_B+x_A;
y_B=v1_y.*t_B+y_A;
z_B=v1_z.*t_B+z_A;

end


%{
+[M函数](,Plane_intersection)
%}

