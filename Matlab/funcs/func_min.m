%% 20220727
%% from 文档\S应用\调光路.ftxt
%{
+[修改标题]"func_min"(,fun_min)
地址::Matlab\funcs\func_min.m
+[保存M函数](,func_min)
+[M函数](,func_min)

测试:...
%}

function x=func_min(f,x0,Dx,N)
%f=@(x)x.^2;
%x0=1;
%Dx=1;
%N=100;

x=x0;
if N>0
    if f(x)>f(x+Dx)
        x=func_min(f,x+Dx,Dx,N-1);
    elseif f(x)>f(x-Dx)
        x=func_min(f,x-Dx,Dx,N-1);
    else
        x=func_min(f,x,Dx/2,N-1);
    end
end

end


%{
+[M函数](,func_min)
%}

