%% 20230528
%% from 文档\S应用\图形库.ftxt
%{
地址::Matlab/draw/tangent_pt_curve.m
+[保存M函数](,tangent_pt_curve)
测试:...
%}

function [i1,i2,Dt]=tangent_pt_curve(pt_0,cv_x,cv_y)

r=sqrt((pt_0(2)-cv_y).^2+(pt_0(1)-cv_x).^2);
Dt=acosd((pt_0(1)-cv_x)./r).*sign_1(pt_0(2)-cv_y);
i1=find(min(Dt)==Dt);
i1=i1(1);
i2=find(max(Dt)==Dt);
i2=i2(1);

end




