%% 20230730
%% from 文档/计算机问题/光线追踪.ftxt
%{
地址::Matlab/tmp/ray_tracing_diffusion.m
+[保存M函数](,ray_tracing_diffusion)

Nini, 打开直线交点的reflect_refract_plane_3D(节点)
%}

function [x_2,y_2,z_2,v_1_x,v_1_y,v_1_z]=ray_tracing_diffusion(x_1,y_1,z_1,v_x,v_y,v_z,t_2,y_x,y_y,y_z)


x_2=x_1+t_2.*v_x;
y_2=y_1+t_2.*v_y;
z_2=z_1+t_2.*v_z;


v2=v_x.^2+v_y.^2+v_z.^2;
yy=-sqrt(y_x.^2+y_y.^2+y_z.^2).*sign(v_x.*y_x+v_y.*y_y+v_z.*y_z);
y_x=y_x./yy;
y_y=y_y./yy;
y_z=y_z./yy;

v_tm_y=(v_x.*y_x+v_y.*y_y+v_z.*y_z);
x_x=v_x-(v_tm_y.*y_x);
x_y=v_y-(v_tm_y.*y_y);
x_z=v_z-(v_tm_y.*y_z);
xx=sqrt(x_x.^2+x_y.^2+x_z.^2);
x_x=x_x./xx;
x_y=x_y./xx;
x_z=x_z./xx;

z_x=x_y.*y_z-x_z.*y_y;
z_y=x_z.*y_x-x_x.*y_z;
z_z=x_x.*y_y-x_y.*y_x;

theta=rand(size(x_1))*pi/2;
phi=rand(size(x_1))*2*pi;

v_1_x=cos(theta).*y_x+sin(theta).*cos(phi).*x_x+sin(theta).*sin(phi).*z_x;
v_1_y=cos(theta).*y_y+sin(theta).*cos(phi).*x_y+sin(theta).*sin(phi).*z_y;
v_1_z=cos(theta).*y_z+sin(theta).*cos(phi).*x_z+sin(theta).*sin(phi).*z_z;

end





