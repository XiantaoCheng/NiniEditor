%% 20221214
%% from 文档\数学问题\反射问题.ftxt
%{
地址::Matlab\space\transform_2D_reflection_surf.m
+[保存M函数](,transform_2D_reflection_surf)
%}

function [X_2,Y_2]=transform_2D_reflection_surf(X,Y,xs,ys,x_0,y_0)

Dx=diff(xs(1:2));
Dy=diff(ys(1:2));
angle=acosd(Dx/norm([Dx,Dy]))*sign_1(Dy)+90
theta=angle*pi/180;
X_2=-(X-x_0).*cos(2.*theta)-(Y-y_0).*sin(2.*theta)+x_0;
Y_2=-(X-x_0).*sin(2.*theta)+(Y-y_0).*cos(2.*theta)+y_0;


end



