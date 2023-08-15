%% 20220721
%% from 文档\数学问题\直线交点.ftxt
%{
+[返回目录](,intersection_lines_dir_pt)
地址::Matlab\space\intersection_lines_dir_pt.m
+[保存M函数](,intersection_lines_dir_pt)
%}

function [x0,y0,X1,Y1,X2,Y2]=intersection_lines_dir_pt(pt1,theta1,pt2,theta2)
X1=[pt1(1),pt1(1)+cos(theta1)];
Y1=[pt1(2),pt1(2)+sin(theta1)];
X2=[pt2(1),pt2(1)+cos(theta2)];
Y2=[pt2(2),pt2(2)+sin(theta2)];

[x0,y0]=intersection_lines(X1,Y1,X2,Y2);

end



