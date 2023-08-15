%% 20221124
%% from 文档\数学问题\直线交点.ftxt
%{
+[保存M函数](,intersection_curve_curve)
地址::Matlab\draw\intersection_curve_curve.m

测试:...
%}

function [xs0,ys0,L1_i,L2_i]=intersection_curve_curve(x1,y1,x2,y2)

addpath('Matlab\draw');
x1_L1=x1(1:end-1);
x1_L2=x1(2:end);
y1_L1=y1(1:end-1);
y1_L2=y1(2:end);

xs0=[];
ys0=[];
L1_i=[];
L2_i=[];

for i=1:length(x1_L1)
    [x0,y0,i_pt]=intersection_line_curve([x1_L1(i),x1_L2(i)],[y1_L1(i),y1_L2(i)],x2,y2);
    xs0=[xs0,x0];
    ys0=[ys0,y0];
    
    L1_i=[L1_i,i*ones(size(x0))];
    L2_i=[L2_i,i_pt];
end


end


%{
+[M函数](,公式验证)
%}

