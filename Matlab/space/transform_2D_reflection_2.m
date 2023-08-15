%% 20221210
%% from 文档\数学问题\反射问题.ftxt
%{
地址::Matlab\space\transform_2D_reflection_2.m
+[保存M函数](,transform_2D_reflection_2)
%}

function [X_2,Y_2]=transform_2D_reflection_2(X,Y,angle,x_0,y_0)

theta=angle*pi/180;
X_2=-(X-x_0).*cos(2.*theta)-(Y-y_0).*sin(2.*theta)+x_0;
Y_2=-(X-x_0).*sin(2.*theta)+(Y-y_0).*cos(2.*theta)+y_0;


end



