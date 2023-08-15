%% 20230219
%% from 文档\物理问题\电透镜.ftxt
%{
地址::Matlab/SEM/field_2D_interp.m
+[保存M函数](,field_2D_interp)
%}

function u=field_2D_interp(X0,Y0,field,x,y,x_min,x_max,y_min,y_max)

u=interp2(X0,Y0,field,x,y);
u(x<x_min | x>x_max | y<y_min | y>y_max)=0;

end

