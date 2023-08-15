%% 20221118
%% from 文档\数学问题\反射问题.ftxt
%{
地址::Matlab\space\transform_2D_reflection.m
+[保存M函数](,transform_2D_reflection)
%}

function [X_2,Y_2]=transform_2D_reflection(X,Y,angle,x_0,y_0)

theta=angle*pi/180;
area_=(X-x_0).*cos(theta)+(Y-y_0).*sin(theta)<=0;
X_2=X;
X_2(area_)=-(X(area_)-x_0).*cos(2.*theta)-(Y(area_)-y_0).*sin(2.*theta)+x_0;
Y_2=Y;
Y_2(area_)=-(X(area_)-x_0).*sin(2.*theta)+(Y(area_)-y_0).*cos(2.*theta)+y_0;


end

