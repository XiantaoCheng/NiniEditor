%% 20230718
%% from 文档\数学问题\函数拟合.ftxt
%{
地址::Matlab/fitting/periodic_self_fitting.m
+[保存M函数](,periodic_self_fitting)
+[打开文件夹]"Matlab/fitting"

测试:...
测试2:...
nargin
%}

function [lm,Df,Df_lm,lm_t]=periodic_self_fitting(x,f,N1,N2,show_mode)

if nargin<5
    show_mode=1;
end

n=N1:N2;
Df=zeros(size(n));

for i=1:length(n)
    dlm=x(2)-x(1);
    lm_t=dlm*n(i);
    xs=linspace(0,lm_t,n(i));
    
    xs_0=xs+x(1);
    f_0=interp1(x,f,xs_0,'spline');
    xs_1=xs+x(1)+lm_t;
    f_1=interp1(x,f,xs_1,'spline');
    
    Df(i)=sum((f_1-f_0).^2);
end

if show_mode==1
    figure
    plot(n,Df)
end
N=n(Df==min(Df));

%fine adjustment
[lm,Df_lm,lm_t]=periodic_self_fitting_2(x,f,N,dlm*N,1.5*dlm,8);

end



function [lm,Df_lm,lm_t]=periodic_self_fitting_2(x,f,N,lm_t0,Dlm,n)

DL=max(x)-min(x);
dlms=linspace(-1,1,10)*Dlm;
lm_t=lm_t0+dlms;
Df_lm=zeros(size(lm_t));

for j=1:length(lm_t)
    Ni=1:DL/lm_t(j);
    Ni(end)=[];
    Df=zeros(size(Ni));
    
    xs=linspace(0,lm_t(j),200);
    xs_0=xs+x(1);
    f_0=interp1(x,f,xs_0,'spline');
    
    for i=1:length(Ni)
        xs_i=xs+x(1)+lm_t(j)*Ni(i);
        f_i=interp1(x,f,xs_i,'spline');
        Df(i)=sum((f_i-f_0).^2);
    end
    Df_lm(j)=sum(Df);
end
lm=lm_t(Df_lm==min(Df_lm));

if n>0
    n=n-1;
    [lm,Df_lm,lm_t]=periodic_self_fitting_2(x,f,N,lm,Dlm/2,n);
end

end

