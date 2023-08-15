%{
+[M函数](,Stage_2nd_Amplifier)
地址::Matlab\optics\Stage_2nd_Amplifier.m
+[保存文本](,Stage_2nd_Amplifier)
%}


function E_out=Stage_2nd_Amplifier(E_s,Dtau,E_p,D,Dx)

% E_s=6e-3;
% E_p=1.29;
% Dx=2.5e-2;
% Dtau=200e-15;
% D=1.2e-2;

physics_constant

E_p=E_p*0.9;

Dt=Dtau*6;
lm_p=532e-9;
lm_s=800e-9;

omega_p=2*pi*c/lm_p;
omega_s=2*pi*c/lm_s;
S=D^2*pi/4;

% N_s=7.0e20*3;
% N_e=3.05e22*0.9;

N_s=E_s/hbar/omega_s/S;
N_e=E_p/hbar/omega_p/S;

t=linspace(0,Dt,500);
x=linspace(0,Dx,500);

n_0=exp(-(t-Dt/2).^2/Dtau^2);
n_0=N_s*n_0/abs(trapz(t,n_0))/c;
Delta_0=exp(-x/Dx);
Delta_0=N_e*Delta_0/abs(trapz(x,Delta_0));

n=n_0;
Delta=Delta_0;
[n,Delta,ratio_n]=PumpAmplify_TiS(t,n,x,Delta);
[n,Delta,ratio_n]=PumpAmplify_TiS(t,n,x,Delta);
[n,Delta,ratio_n]=PumpAmplify_TiS(t,n,x,Delta);

N_out=abs(trapz(t,n))*c;
E_out=N_out*hbar*omega_s*S;


end


%{
+[M函数](,Stage_2nd_Amplifier)
%}