%% 20221214
%% from 文档\S应用\光线传播.ftxt
%{
地址::Matlab\optics\Reflection_curve_2D.m
测试:...
+[保存M函数](,Reflection_curve_2D)
%}

function [x2,y2,an2,angle]=Reflection_curve_2D(x1,y1,an1,xs,ys)
addpath("Matlab\draw");

% x1=[-10,0.5];
% y1=[5,0.2];
% Dx=diff(x1(1:2));
% Dy=diff(y1(1:2));
% an1=acosd(Dx/norm([Dx,Dy]))*sign_1(Dy);

Dx1=cosd(an1);
Dy1=sind(an1);
xs1=[x1,x1+Dx1];
ys1=[y1,y1+Dy1];

[~,~,~,x0,y0,on_1,on_2]=intersection_line_curve(xs1,ys1,xs,ys);
DL=(x0-x1(1))*Dx1+(y0-y1(1))*Dy1;
DL_min=min(DL(on_2 & DL>1e-9));

if isempty(DL_min)
    an2=nan;
    x2=nan;
    y2=nan;
    angle=nan;
else
    i_p=find(DL==DL_min(1));
    
    Dx=diff(xs(i_p:i_p+1));
    Dy=diff(ys(i_p:i_p+1));
    angle=acosd(Dx/norm([Dx,Dy]))*sign_1(Dy);
    
    an2=2*angle-an1;
    x2=x0(DL==DL_min(1));
    y2=y0(DL==DL_min(1));
end

end

%{
+[保存M函数](,Reflection_curve_2D)
%}

