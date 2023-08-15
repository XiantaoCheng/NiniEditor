%% 20220727
%% from 文档\S应用\调光路.ftxt
%{
地址::Matlab\min_simulator\f2.m
+[保存M函数](,f2)
+[M函数](,f2)
%}


function error2=f2(p1,p2)
N=1200;
n=-1;
lm1=800e-9;
lm2=700e-9;

pt0=[0,20];
angle0=-90;
G1_pt=[0,0];
G1_angle=135+p1;
G2_pt=[-10,10];
G2_angle=-45;
P1_pt=[0,-10];
P1_angle=90+p2;
M3_pt=[0,10];
M3_angle=-45;
tg_pt=[100,10];
tg_angle=180;

pt1=grating_compressor_path(lm1,n,N,pt0,angle0,G1_pt,G1_angle,G2_pt,G2_angle,P1_pt,P1_angle,M3_pt,M3_angle,tg_pt,tg_angle);
pt2=grating_compressor_path(lm2,n,N,pt0,angle0,G1_pt,G1_angle,G2_pt,G2_angle,P1_pt,P1_angle,M3_pt,M3_angle,tg_pt,tg_angle);

error2=pt1(2)-pt2(2);

end


