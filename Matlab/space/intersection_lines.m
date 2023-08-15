%% 20220721
%% from 文档\数学问题\直线交点.ftxt
%{
+[返回目录](,intersection_lines)
地址::Matlab\space\intersection_lines.m
+[保存M函数](,intersection_lines)
%}

function [x0,y0]=intersection_lines(L1x,L1y,L2x,L2y)
x1=L1x;
y1=L1y;
x2=L2x;
y2=L2y;
D1=x1(1).*y1(2)-x1(2).*y1(1);
D2=x2(1).*y2(2)-x2(2).*y2(1);
Dx1=x1(2)-x1(1);
Dx2=x2(2)-x2(1);
Dy1=y1(2)-y1(1);
Dy2=y2(2)-y2(1);
x0=(D1*Dx2-D2*Dx1)/(Dy1*Dx2-Dy2*Dx1);
y0=(D1*Dy2-D2*Dy1)/(Dy1*Dx2-Dy2*Dx1);
end



