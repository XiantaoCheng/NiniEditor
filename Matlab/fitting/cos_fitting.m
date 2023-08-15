%% 20230608
%% from 文档\数学问题\函数拟合.ftxt
%{
地址::Matlab\fitting\cos_fitting.m
+[保存M函数](,cos_fitting)

测试:...
+[新建阅读窗口](,测试)
%}


function [f,lm_1,A_1,phi_1]=cos_fitting(x0,f0,N)

A_0=max(f0);
phi_0=acos(f0(1)/A_0);
f_t=@(x,A,lm,phi)A*cos((x-x0(1))*2*pi/lm+phi);

[k,F]=fft_x(x0,f0);
F=abs(F);
k_0=k(F==max(F)&k>0);
lm_0=2*pi/k_0(1);
Dlm=lm_0/30;

lm_1=lm_0;
phi_1=phi_0;
Dphi=0.1;
A_1=A_0;
DA=A_0/30;
for j=1:N
    lms=lm_1+linspace(-1,1,100)*Dlm;
    Q_f=zeros(size(lms));
    for i=1:length(lms)
        Q_f(i)=trapz(x0,(f0-f_t(x0,A_1,lms(i),phi_1)).^2);
    end
    lm_1=lms(Q_f==min(Q_f));
    lm_1=lm_1(1);

    phis=phi_1+linspace(-1,1,10)*Dphi;
    Q_f=zeros(size(phis));
    for i=1:length(phis)
        Q_f(i)=trapz(x0,(f0-f_t(x0,A_1,lm_1,phis(i))).^2);
    end
    phi_1=phis(Q_f==min(Q_f));
    phi_1=phi_1(1);

    As=A_1+linspace(-1,1,10)*DA;
    Q_f=zeros(size(As));
    for i=1:length(As)
        Q_f(i)=trapz(x0,(f0-f_t(x0,As(i),lm_1,phi_1)).^2);
    end
    A_1=As(Q_f==min(Q_f));
    A_1=A_1(1);


    Dlm=Dlm/5;
    Dphi=Dphi/1.3;
    DA=DA/3;
end

f=@(x)A_1*cos((x-x0(1))*2*pi/lm_1+phi_1);

end

%{
+[保存M函数](,cos_fitting)
%}

