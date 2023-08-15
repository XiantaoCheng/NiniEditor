%% 20230413
%% from 文档/物理问题/ShadowSpectrometer.ftxt
%{
地址::Matlab/funcs/Gaussian_expansion.m
+[保存M函数](,Gaussian_expansion)

测试:...
%}

function [g,A]=Gaussian_expansion(f,x,B)

F=zeros(size(B));
for i=1:length(B)
    F(i)=trapz(x,f.*exp(-B(i)*x.^2));
end
T=sqrt(pi./(B'+B));
A=F/T;

g=zeros(size(x));
for i=1:length(A)
    g=g+A(i)*exp(-B(i)*x.^2);
end

end

%{
+[M函数](,验证公式)
%}

