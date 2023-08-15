%% 20230422
%% from 文档/数学问题/有限元分析.ftxt
%{
+[保存M函数](,intersection_line_lines_2)
地址::Matlab\space\intersection_line_lines_2.m
%}

function [x0,y0,i,xs0,ys0,on_line1,on_line2]=intersection_line_lines_2(x1,y1,x2,y2)

% x1=[2,0];
% y1=[0.2,0.5];
% x2=[0,1,2,3];
% y2=[0,1,0,1];

x2_L1=x2(1,:);
x2_L2=x2(2,:);
y2_L1=y2(1,:);
y2_L2=y2(2,:);

D1=x1(1).*y1(2)-x1(2).*y1(1);
D2=x2_L1.*y2_L2-x2_L2.*y2_L1;
Dx1=x1(2)-x1(1);
Dx2=x2_L2-x2_L1;
Dy1=y1(2)-y1(1);
Dy2=y2_L2-y2_L1;
x0=(D1*Dx2-D2*Dx1)./(Dy1*Dx2-Dy2*Dx1);
y0=(D1*Dy2-D2*Dy1)./(Dy1*Dx2-Dy2*Dx1);

Ds2=(x0-x2_L1).*(x2_L2-x2_L1)+(y0-y2_L1).*(y2_L2-y2_L1);
Ls2=sqrt((x2_L2-x2_L1).^2+(y2_L2-y2_L1).^2);
Ds1=(x0-x1(1)).*(x1(2)-x1(1))+(y0-y1(1)).*(y1(2)-y1(1));
Ls1=sqrt((x1(2)-x1(1)).^2+(y1(2)-y1(1)).^2);

on_line2=(Ds2./Ls2.^2>=-1e-10 & Ds2./Ls2.^2<=1+1e-10);
on_line1=(Ds1./Ls1.^2>=-1e-10 & Ds1./Ls1.^2<=1+1e-10);

xs0=x0;
ys0=y0;
x0=xs0(on_line1 & on_line2);
y0=ys0(on_line1 & on_line2);
i=find(on_line1 & on_line2);
end


%{
+[保存M函数](,intersection_line_lines_2)
%}

