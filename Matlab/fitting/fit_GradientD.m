%% 20230508
%% from 文档\数学问题\函数拟合.ftxt
%{
地址::Matlab/fitting/fit_GradientD.m
+[保存M函数](,fit_GradientD)

参考::https://zhuanlan.zhihu.com/p/37524275
参考2::https://en.wikipedia.org/wiki/Gradient_descent
参考3::https://en.wikipedia.org/wiki/Newton%27s_method
+[打开网页](,参考2)

保存:...
%}


function [A,dfdA,steps]=fit_GradientD(A0,ds,loss,N)

% f=@(x,A)A(1)*exp(-(x-A(2)).^2/A(3)^2);
% Df=@(A)std(f(x0,A)-i0);
% A0=[300,0,2e-3];
% ds=1e-5;

dA=1e-1;
A=A0;
dfdA=zeros(size(A));
steps=zeros(N,length(A));

for n=1:N
    for i=1:length(A)
        dA_x=zeros(size(A));
        dA_x(i)=dA*1e-3;
        dfdA(i)=(loss(A+dA_x/2)-loss(A-dA_x/2))/dA;
    end

    if n>1
        ds=abs(sum((A-A1).*(dfdA-dfdA1))./norm(dfdA-dfdA1)^2);
    end
    if isnan(ds)
        break
    end

    A1=A;
    dfdA1=dfdA;

    A=A-dfdA*ds*1e-1;
    steps(n,:)=A;
    dA=norm(A-A1);

end


end


%{
+[保存M函数](,fit_GradientD)
%}

