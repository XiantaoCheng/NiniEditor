%% 20220806
%% from 文档\数学问题\直线交点.ftxt
%{
+[返回目录](,intersection_lines_path)
地址::Matlab\space\intersection_lines_path.m
+[保存M函数](,intersection_lines_path)
%}

function [x_s,y_s]=intersection_lines_path(x_0,y_0,dxs,dys)

D_s=x_0.*dys-y_0.*dxs;

D_1=D_s(1:end-1);
D_2=D_s(2:end);
Delta_x1=dxs(1:end-1);
Delta_y1=dys(1:end-1);
Delta_x2=dxs(2:end);
Delta_y2=dys(2:end);

x_s=(D_1.*Delta_x2-D_2.*Delta_x1)./(Delta_y1.*Delta_x2-Delta_y2.*Delta_x1);
y_s=(D_1.*Delta_y2-D_2.*Delta_y1)./(Delta_y1.*Delta_x2-Delta_y2.*Delta_x1);

end



