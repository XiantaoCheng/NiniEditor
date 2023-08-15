%{
+[M函数](,cirlce_3_pt)

地址::Matlab\geometry\cirlce_3_pt.m
+[保存文本](,cirlce_3_pt)
%}

function [x0,y0,R]=cirlce_3_pt(x,y)
%x=[1,2,2];
%y=[0,0,1];

Dx12=x(1)-x(2);
Dx23=x(2)-x(3);
Dy12=y(1)-y(2);
Dy23=y(2)-y(3);

X12=mean(x(1:2));
X23=mean(x(2:3));
Y12=mean(y(1:2));
Y23=mean(y(2:3));

A=Dx12*X12+Dy12*Y12;
B=Dx23*X23+Dy23*Y23;

x0=(A*Dy23-B*Dy12)/(Dx12*Dy23-Dx23*Dy12);
y0=(-A*Dx23+B*Dx12)/(Dx12*Dy23-Dx23*Dy12);
R=sqrt((x(2)-x0)^2+(y(2)-y0)^2);
end

%{
+[M函数](,验证公式)
%}