%{
+[返回目录](,经过材料)
地址::Matlab\Physics\RelativisticBF.m
+[保存文本](,经过材料)

Smilei单位::https://smileipic.github.io/Smilei/units.html
Smilei内置函数::https://smileipic.github.io/Smilei/namelist.html#profiles
+[打开](,Smilei内置函数)
+[matlabStart](,Matlab)

+[M函数](,经过材料)

测试:...
测试输出模式:...
+[M函数](,测试)
%}

function [Ey,Ez,Dphi1,Dphi2,mode]=RelativisticBF(E0,G0,X,density,t,lmbd0)

%addpath('C:\Users\cheng\Dropbox\Struct\Structure1.2\Nini\Matlab\Physics')
%addpath('C:\Users\cheng\Dropbox\Struct\Structure1.2\Nini\Matlab\Smilei')

%E0=[1,1];
%G0=5;
%X=linspace(0,400,1000);
%density=@(x)trapezoidal(x,20,20,150,20,0.4);
%t=500;
%w0=10;

physics_constant;

w0=2*pi*c/lmbd0;
dx=X(2)-X(1);
mode=[1,0;
      0,1];
A=EigDecomposition(E0,mode);


Dphi1=zeros(size(X));
Dphi2=Dphi1;
for i=1:length(X)
    x=[0,0:dx:X(i)];
    wp=sqrt(e^2*density(x)/me/epsilon0);
    ni1=sqrt(1./(1-wp.^2/w0^2/G0^3));
    %ni1=sqrt(1./(1-wp.^2/w0^2));
    ni2=sqrt(1./(1-wp.^2/w0^2/G0));
    Dphi1(i)=trapz(x,ni1*w0/c)+t;
    Dphi2(i)=trapz(x,ni2*w0/c)+t;
end


Ey1=A(1);
Ey2=0;
Ez1=0;
Ez2=A(2);
Ey=Ey1*exp(-1i*Dphi1)+Ey2*exp(-1i*Dphi2);
Ez=Ez1*exp(-1i*Dphi1)+Ez2*exp(-1i*Dphi2);
Ey(X>t*c)=0;
Ez(X>t*c)=0;

%plot(X,real(Ez),X,real(Ey))
end