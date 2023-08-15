%% 20230125
%% from 文档\计算机问题\合并多边形.ftxt
%{
地址::Matlab\space\PtInPolygon.m
+[保存M函数](,PtInPolygon)

测试:...
%}



function [ioo,n_w]=PtInPolygon(x1,y1,x2,y2)

x2(end+1)=max(x1)+3;
y2(end+1)=y2;
[x0,y0,i]=intersection_line_curve(x2,y2,x1,y1);

ioo=1-mod(length(i),2);
n_w=sum(sign(y2(1)-y1(i)));

end

%{
+[M函数](,验证公式)
%}

