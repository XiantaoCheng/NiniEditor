%% 20220722
%% from 文档\物理问题\光栅压缩器.ftxt
%{
地址::Matlab\optics\grating_compressor_path.m
+[保存M函数](,grating_compressor_path)
%}


function [pt7,x,y]=grating_compressor_path(lm_B,n,N,pt0,angle0,G1_pt,G1_angle,G2_pt,G2_angle,P0_pt,P0_angle,M3_pt,M3_angle,tg_pt,tg_angle)

addpath('Matlab\space')

%N=1200;
%lm_B=750e-9;
%n=-1;

%pt0=[0,20];
%angle0=-90;

%G1_pt=[0,0];
%G1_angle=135;
%G2_pt=[-10,10];
%G2_angle=-44;
%P0_pt=[0,-10];
%P0_angle=90;
%M3_pt=[0,10];
%M3_angle=-45;
%tg_pt=[100,10];
%tg_angle=180;


[x1,y1,angle]=Reflection_grating(pt0,angle0,G1_pt,G1_angle,N,lm_B,n);
[x2,y2,angle]=Reflection_grating([x1,y1],angle,G2_pt,G2_angle,N,lm_B,n);
[x3,y3,angle]=Reflection_grating([x2,y2],angle,P0_pt,P0_angle,N,lm_B,0);
[x4,y4,angle]=Reflection_grating([x3,y3],angle,G2_pt,G2_angle,N,lm_B,n);
[x5,y5,angle]=Reflection_grating([x4,y4],angle,G1_pt,G1_angle,N,lm_B,n);
[x6,y6,angle]=Reflection_grating([x5,y5],angle,M3_pt,M3_angle,N,lm_B,0);
[x7,y7,angle]=Reflection_grating([x6,y6],angle,tg_pt,tg_angle,N,lm_B,0);


%plot([pt0(1),x1,x2,x3,x4,x5,x6,x7],[pt0(2),y1,y2,y3,y4,y5,y6,y7])
%axis equal
pt7=[x7,y7];
x=[pt0(1),x1,x2,x3,x4,x5,x6,x7];
y=[pt0(2),y1,y2,y3,y4,y5,y6,y7];

end

%{
+[M函数](,光线路径)
+[修改天使]
%}

