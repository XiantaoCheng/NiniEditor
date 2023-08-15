%% 20230730
%% from 文档/数学问题/曲面交点.ftxt
%{
地址::Matlab/optics/reflect_refract_sphere_3D.m
+[保存M函数](,reflect_refract_sphere_3D)

测试:...
%}
function [x_2,y_2,z_2,v_1_x,v_1_y,v_1_z,v_2_x,v_2_y,v_2_z]=reflect_refract_sphere_3D(x_1,y_1,z_1,v_x,v_y,v_z,t_2,x_0,y_0,z_0,R,n_1,n_2)


x_2=x_1+t_2.*v_x;
y_2=y_1+t_2.*v_y;
z_2=z_1+t_2.*v_z;


v2=v_x.^2+v_y.^2+v_z.^2;

y_x=x_1+t_2.*v_x-x_0;
y_y=y_1+t_2.*v_y-y_0;
y_z=z_1+t_2.*v_z-z_0;
yy=sqrt(y_x.^2+y_y.^2+y_z.^2);
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

v_tm_x=(v_x.*x_x+v_y.*x_y+v_z.*x_z);

% reflection
v_1_x=v_tm_x.*x_x-v_tm_y.*y_x;
v_1_y=v_tm_x.*x_y-v_tm_y.*y_y;
v_1_z=v_tm_x.*x_z-v_tm_y.*y_z;

% refraction
v_2_x=v_tm_x.*x_x+sqrt((n_2./n_1).^2.*v2-v_tm_x.^2).*y_x.*sign(v_tm_y);
v_2_y=v_tm_x.*x_y+sqrt((n_2./n_1).^2.*v2-v_tm_x.^2).*y_y.*sign(v_tm_y);
v_2_z=v_tm_x.*x_z+sqrt((n_2./n_1).^2.*v2-v_tm_x.^2).*y_z.*sign(v_tm_y);



end




