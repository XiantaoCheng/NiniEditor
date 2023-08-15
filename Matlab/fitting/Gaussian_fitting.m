%% 20230511
%% from 文档\数学问题\函数拟合.ftxt
%{
+[M函数](,Gaussian_fitting)
地址::Matlab\fitting\Gaussian_fitting.m
+[保存M函数](,Gaussian_fitting)
%}


function [f,D1,A1,B1]=Gaussian_fitting(x1,i1,N)
% N=100;

dX=abs(x1-x1(1));
dx=min(dX(dX~=0));
Dx=max(x1)-min(x1);

S1=trapz(x1,i1);
B1=sum(x1.*i1)/sum(i1);
D1=linspace(dx,Dx,N);
A1=S1/sqrt(pi)./D1;

dY=zeros(1,N);
for j=1:3
    for i=1:N
        y1=A1(i)*exp(-(x1-B1).^2/D1(i)^2);
        dY(i)=sum((y1-i1).^2/numel(y1));
    end

    D0=D1(dY==min(dY));
    D0=D0(1);
    D1=linspace(D0-3*dx,D0+3*dx,N);
    A1=S1/sqrt(pi)./D1;
    dx=dx/N;
end

D1=D1(dY==min(dY));
D1=D1(1);
A1=S1/sqrt(pi)/D1;

f=@(x)A1*exp(-(x-B1).^2/D1^2);

end

%{
+[M函数](,测试拟合)
%}

