%% 20220416
%% from 文档\物理问题\电子能谱.ftxt
%{
+[M函数](,spectrum_x)
Nini, 打开能谱仪原理的trajectory_fiducial(节点)

地址::Matlab\spectrometer\spectrum_x.m
+[保存M函数](,spectrum_x)

测试:...
存档_单位1:...
%}

function [E0,y,x0,y0]=spectrum_x(bd_0,bd_1,pos_s,theta_e,pos_m0,siz_m0,B,pos_p0,theta_p0,N)

physics_constant;

x_f=[bd_0(1),bd_1(1)];
y_f=[bd_0(2),bd_1(2)];
xe=pos_s(1);
ye=pos_s(2);
pos_m=pos_m0(1:2);
siz_m=siz_m0;
pos_p=pos_p0(1:2);
theta_p=theta_p0(1);

E_bd = trajectory_fiducial(x_f,y_f,xe,ye,theta_e,pos_m(1:2),siz_m,B);

E_bd(isnan(E_bd))=20e9*e;
E0=linspace(E_bd(1),E_bd(2),N);
xe1=pos_s(1)*ones(size(E0));
ye1=pos_s(2)*ones(size(E0));
theta=theta_e*ones(size(E0));

[x0,y0] = trajectory_uniform(xe1,ye1,theta,E0,pos_m(1:2),siz_m,B,pos_p(1:2),theta_p);
y=-sind(theta_p)*(x0-pos_p(1))+cosd(theta_p)*(y0-pos_p(2));


end

%{
+[保存M函数](,spectrum_x)
%}

