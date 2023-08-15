%{
+[返回目录](,�?过�??料)
地�?�::Matlab\Physics\FaradayRotation.m
+[命令行]"md Matlab\Physics"
+[�?存文本](,�?过�??料)

Smilei�?��?::https://smileipic.github.io/Smilei/units.html
Smilei内置函数::https://smileipic.github.io/Smilei/namelist.html#profiles
+[打开](,Smilei内置函数)
+[matlabStart](,Matlab)

+[M函数](,�?过�??料)
备份:...

trapezoidal:...
测试:...
测试输出模�?:...
+[修改内容](测试,测试输出模�?)
+[M函数](,测试)
%}

function [Ey,Ez,Dphi1,Dphi2,mode]=FaradayRotation(E0,B0,X,density,t,lmbd0)
%addpath('Matlab\\Smilei')
%addpath('Matlab\\Physics')

%E0=[1,1]/sqrt(2);
%B0=10000;
%ne=1e25;
%X=linspace(0,300e-6,10000);
%density=@(x)trapezoidal(x,20e-6,20e-6,150e-6,20e-6,ne);
%t=900e-15;
%lmbd0=800e-9;

physics_constant;

w0=2*pi*c/lmbd0;
W=e*B0/me;
dx=X(2)-X(1);

mode=[1i,-1;
      1,-1i]/sqrt(2);
A=EigDecomposition(E0,mode);

physics_constant;

Dphi1=zeros(size(X));
Dphi2=Dphi1;
for i=1:length(X)
    x=[0,0:dx:X(i)];
    wp=sqrt(e^2*density(x)/epsilon0/me);
    ni1=sqrt(1-wp.^2/w0/(w0-W));
    ni2=sqrt(1-wp.^2/w0/(w0+W));
    trapz(x,ni1*w0/c);
    Dphi1(i)=trapz(x,ni1*w0/c)+t;
    Dphi2(i)=trapz(x,ni2*w0/c)+t;
end


Ey1=A(1)*1i/sqrt(2);
Ey2=-A(2)*1i/sqrt(2)*exp(-1i*pi/2);
Ez1=A(1)*1/sqrt(2);
Ez2=A(2)*1/sqrt(2)*exp(-1i*pi/2);
Ey=Ey1*exp(-1i*Dphi1)+Ey2*exp(-1i*Dphi2);
Ez=Ez1*exp(-1i*Dphi1)+Ez2*exp(-1i*Dphi2);
Ey(X>t*c)=0;
Ez(X>t*c)=0;

%subplot(2,1,1)
%plot(X,Ez)
%subplot(2,1,2)
%plot(X,density(X))

end