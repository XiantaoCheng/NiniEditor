%% 20220724
%% from 文档\S应用\齿轮模拟.ftxt
%{
地址::Matlab\gears\frame_from_pts.m
+[保存M函数](,frame_from_pts)
测试:...
%}

function [pt,angle,vx,vy]=frame_from_pts(pt1_g,pt2_g,pt1_l,pt2_l)

dpt_g=pt2_g-pt1_g;
dpt_l=pt2_l-pt1_l;
dpt_g=dpt_g/norm(dpt_g);
dpt_g(isnan(dpt_g))=0;
dpt_l=dpt_l/norm(dpt_l);
dpt_l(isnan(dpt_l))=0;

angle_g=acosd(dpt_g(1))*sign_1(dpt_g(2));
angle_l=acosd(dpt_l(1))*sign_1(dpt_l(2));
angle=angle_g-angle_l;
vx=[cosd(angle),sind(angle)];
vy=[sind(angle),-cosd(angle)];
pt=pt1_g-vx*pt1_l(1)-vy*pt1_l(2);

end

%{
+[保存M函数](,frame_from_pts)
%}

