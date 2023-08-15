%% 20220724
%% from 文档\S应用\齿轮模拟.ftxt
%{
地址::Matlab\gears\frame_from_pt_angle.m
测试:...
+[保存M函数](,frame_from_pt_angle)
%}

function [pt,angle]=frame_from_pt_angle(pt_g,angle_g,pt_l,angle_l)
pt=pt_g-pt_l;
angle=angle_g-angle_l;
end





