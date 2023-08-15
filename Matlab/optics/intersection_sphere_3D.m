%% 20230715
%% from 文档/数学问题/曲面交点.ftxt
%{
地址::Matlab/optics/intersection_sphere_3D.m
+[保存M函数](,intersection_sphere_3D)

测试:...
%}

function [t_2,t_3]=intersection_sphere_3D(x_1,y_1,z_1,v_x,v_y,v_z,x_0,y_0,z_0,R)


v2=v_x.^2+v_y.^2+v_z.^2;
t_2=(-(v_x.*(x_1-x_0)+v_y.*(y_1-y_0)+v_z.*(z_1-z_0))+sqrt((v_x.*(x_1-x_0)+v_y.*(y_1-y_0)+v_z.*(z_1-z_0)).^2-v2.*((x_1-x_0).^2+(y_1-y_0).^2+(z_1-z_0).^2-R.^2)))./v2;
t_3=(-(v_x.*(x_1-x_0)+v_y.*(y_1-y_0)+v_z.*(z_1-z_0))-sqrt((v_x.*(x_1-x_0)+v_y.*(y_1-y_0)+v_z.*(z_1-z_0)).^2-v2.*((x_1-x_0).^2+(y_1-y_0).^2+(z_1-z_0).^2-R.^2)))./v2;


end




