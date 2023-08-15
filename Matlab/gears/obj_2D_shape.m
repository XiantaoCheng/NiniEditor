%% 20220725
%% from 文档\S应用\齿轮模拟.ftxt
%{
地址::Matlab\gears\obj_2D_shape.m
+[保存M函数](,obj_2D_shape)

测试:...
gear_2D(M函数):...
rect_2D(M函数):...
%}

function obj_2D_shape(x0,y0,angle,pt,color)

if nargin<5
color=[0,0,0];
end

x=cosd(angle)*x0-sind(angle)*y0+pt(1);
y=cosd(angle)*y0+sind(angle)*x0+pt(2);
patch(x,y,[1,1,1],'EdgeColor',color)

end




