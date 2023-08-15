%% 20221118
%% from 文档\数学问题\反射问题.ftxt
%{
地址::Matlab\space\transform_2D_reflection_inv.m
+[保存M函数](,transform_2D_reflection_inv)
%}

function [X_1,Y_1,X_2,Y_2]=transform_2D_reflection_inv(X,Y,angle,x_0,y_0)

theta=angle*pi/180;
X_1=X;
X_2=-(X-x_0).*cos(2.*theta)-(Y-y_0).*sin(2.*theta)+x_0;
Y_1=Y;
Y_2=-(X-x_0).*sin(2.*theta)+(Y-y_0).*cos(2.*theta)+y_0;

area_=(X-x_0).*cos(theta)+(Y-y_0).*sin(theta)<=0;
X_1(area_)=nan;
Y_1(area_)=nan;
X_2(area_)=nan;
Y_2(area_)=nan;


end

