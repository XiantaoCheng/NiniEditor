%% 20220727
%% from 文档\物理问题\BBO相位匹配.ftxt
%{
BBO相位匹配
地址::Matlab\funcs\func_zero.m
+[保存M函数](,func_zero)

测试:...
%}

function x0=func_zero(f,x1,x2,N)

%lm1=800e-9;
%lm2=1500e-9;
%f=@(beta)BBO_Dk(lm1,lm2,beta,'eoo');
%N=10;

%x1=0;
%x2=90;

if f(x1)==0
    x0=x1;
elseif f(x2)==0
    x0=x2;
else
    x0=(x1+x2)/2;
end

if f(x0)~=0 && N~=0
    if f(x0)*f(x1)<0
        x0=func_zero(f,x0,x1,N-1);
    else
        x0=func_zero(f,x0,x2,N-1);
    end
end


end


%{

%}

