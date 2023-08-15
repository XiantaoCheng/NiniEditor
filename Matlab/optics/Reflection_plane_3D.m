%{
+[返回目录](,Reflection_plane_3D)
+[M函数](,Reflection_plane_3D)
地址::Matlab\optics\Reflection_plane_3D.m

测试(M函数):...

+[保存文本](,Reflection_plane_3D)
%}
function [x_B,y_B,z_B,v2_x,v2_y,v2_z]=Reflection_plane_3D(x_A,y_A,z_A,v1_x,v1_y,v1_z,r0,Eulers)
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

v2_x=v1_x-2*A*s(1);
v2_y=v1_y-2*A*s(2);
v2_z=v1_z-2*A*s(3);

end


%{
+[M函数](,抛物型柱面镜反射)
%}