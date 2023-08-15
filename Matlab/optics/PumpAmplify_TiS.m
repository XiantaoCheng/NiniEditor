%{
+[M函数](,PumpAmplify_TiS)
地址::Matlab\optics.\PumpAmplify_TiS.m
+[保存文本](,PumpAmplify_TiS)

Dt=1200e-15;
Dx=2.5e-2;
Dtau=200e-15;
N_p=1.7e19;
N_e=3.05e22;

t=linspace(0,Dt,300);
x=linspace(0,Dx,200);

n_0=exp(-(t-Dt/2).^2/Dtau^2);
n_0=N_p*n_0/abs(trapz(t,n_0))/c;
Delta_0=exp(-x/Dx);
Delta_0=N_e*Delta_0/abs(trapz(x,Delta_0));

%}


function [n,Delta,ratio_n]=PumpAmplify_TiS(t,n_0,x,Delta_0)
physics_constant;
sigma=3e-23;

x0=max(x);
t0=x0/c;
dx=x(2)-x(1);
dt=t(2)-t(1);

% n output
int_n=cumsum(n_0)*dt;
int_D=trapz(x,Delta_0);
A=exp(-2*sigma*c*int_n);
B=1-exp(-sigma*int_D);
ratio_n=1./(1-B*A);
n=n_0.*ratio_n;

% Delta output
exp_D=exp(-sigma*cumsum(Delta_0)*dx);
exp_n=exp(2*sigma*c*trapz(t,n_0));
ratio_D=exp_D./(exp_n+exp_D-1);
Delta=Delta_0.*ratio_D;

end

%{
+[M函数](,PumpAmplify_TiS)
+[matlab]"plot(t,n)"(Matlab,)
+[matlab]"plot(t,ratio_n)"(Matlab,)
+[matlab]"plot(x,Delta_0)"(Matlab,)
+[matlab]"plot(t,A)"(Matlab,)
+[matlab]"plot(x,Delta,x,Delta_0);set(gca,'YScale','log')"(Matlab,)
+[matlab]"plot(int_n)"(Matlab,)
+[matlab]"trapz(t,n_0)"(Matlab,)
+[matlab]"B"(Matlab,)
%}