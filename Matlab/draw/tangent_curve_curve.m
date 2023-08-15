%% 20230528
%% from 文档\S应用\图形库.ftxt
%{
地址::Matlab/draw/tangent_curve_curve.m
+[保存M函数](,tangent_curve_curve)
测试:...
+[新建阅读窗口](,测试)
%}

function [i1,i2,j1,j2]=tangent_curve_curve(cv_x1,cv_y1,cv_x2,cv_y2,N)

i1=1;
i2=1;
for n=1:N
    [j1,~]=tangent_pt_curve([cv_x1(i1),cv_y1(i1)],cv_x2,cv_y2);
    [~,i1]=tangent_pt_curve([cv_x2(j1),cv_y2(j1)],cv_x1,cv_y1);
    [~,j2]=tangent_pt_curve([cv_x1(i2),cv_y1(i2)],cv_x2,cv_y2);
    [i2,~]=tangent_pt_curve([cv_x2(j2),cv_y2(j2)],cv_x1,cv_y1);
end


end




