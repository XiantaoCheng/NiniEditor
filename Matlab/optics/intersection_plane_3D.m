%% 20230730
%% from 文档\数学问题\直线交点.ftxt
%{
地址::Matlab/optics/intersection_plane_3D.m
+[保存M函数](,intersection_plane_3D)
r0
%}
function [t_B,s]=intersection_plane_3D(x_A,y_A,z_A,v1_x,v1_y,v1_z,X,Y,Z)

Dr1=[X(1)-X(2),Y(1)-Y(2),Z(1)-Z(2)];
Dr2=[X(2)-X(3),Y(2)-Y(3),Z(2)-Z(3)];
s=cross(Dr1,Dr2);
r0=[X(1),Y(1),Z(1)];
A=s(1)*v1_x+s(2)*v1_y+s(3)*v1_z;

t_B=(s(1)*(r0(1)-x_A)+s(2)*(r0(2)-y_A)+s(3)*(r0(3)-z_A))./A;
x_B=v1_x.*t_B+x_A;
y_B=v1_y.*t_B+y_A;
z_B=v1_z.*t_B+z_A;

end


%{
+[M函数](,Plane_intersection)
%}

