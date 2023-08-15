%% 20230114
%% from 文档\物理问题\静电场.ftxt
%{
地址::Matlab\funcs\besseljzero.m
+[保存M函数](,besseljzero)
%}

function roots=besseljzero(n,m)

J_n=@(x)besselj(n,x);

roots=zeros(size(m));
for i=1:length(m)
    roots(i)=func_zero(J_n,(m(i)-1)*pi,m(i)*pi,500);
end

end

