%% 20220808
%% from 文档\物理问题\plasma.ftxt
%{
地址::Matlab\funcs\func_max.m
+[保存M函数](,func_max)
+[M函数](,func_max)
%}


function x=func_max(f,x0,Dx,N)
%f=@(x)x.^2;
%x0=1;
%Dx=1;
%N=100;


x=x0;
if N>0
    if f(x)<f(x+Dx)
        x=func_max(f,x+Dx,Dx,N-1);
    elseif f(x)<f(x-Dx)
        x=func_max(f,x-Dx,Dx,N-1);
    else
        x=func_max(f,x,Dx/2,N-1);
    end
end


end

%{
+[M函数](,func_min)
%}




