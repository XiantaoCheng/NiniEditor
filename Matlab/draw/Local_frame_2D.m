%% 20221201
%% from 文档\S应用\人体模型.ftxt
%{
地址::Matlab\draw\Local_frame_2D.m
+[保存M函数](,Local_frame_2D)
%}


function [xs,ys]=Local_frame_2D(xs_0,ys_0,fm_x,fm_y)


v_y1=[diff(fm_x),diff(fm_y)];
L1=norm(v_y1);
% v_y1=v_y1/L1;
v_x1=[v_y1(2),-v_y1(1)];
pt_1=[fm_x(1),fm_y(1)];


xs=v_x1(1)*xs_0+v_y1(1)*ys_0+pt_1(1);
ys=v_x1(2)*xs_0+v_y1(2)*ys_0+pt_1(2);


end






