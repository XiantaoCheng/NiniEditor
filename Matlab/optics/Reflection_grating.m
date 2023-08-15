%% 20220721
%% from 文档\物理问题\光栅原理.ftxt
%{
地址::Matlab\optics\Reflection_grating.m
+[保存M函数](,Reflection_grating)

测试:...
%}

function [x1,y1,angle_out]=Reflection_grating(pt0,angle0,G1_pt,G1_angle,N,lm_B,n)
physics_constant;
addpath('Matlab\space')

%N=1200;
%lm_B=800e-9;
%n=1;

%G1_pt=[0,0];
%G1_angle=45;
%pt0=[0,1];
%angle0=-100;

[x1,y1]=intersection_lines_dir_pt(G1_pt,(G1_angle+90)/180*pi,pt0,angle0/180*pi);

alpha=angle0+180-G1_angle;
d=1/N*1e-3;
beta=asind(sind(alpha)-n*lm_B/d);
angle_out=G1_angle-beta;


end

%{
+[M函数](,验证计算)
%}

