%{
+[M函数](,PumpAmplify_TiS_intensity)
地址::Matlab\optics\PumpAmplify_TiS_intensity.m
+[保存文本](,PumpAmplify_TiS_intensity)
Dx
是([动词库],动词)->+[打开文件](+新窗口,动词)
+[显示](,地址)
%}

function [Js_out,Jp_out]=PumpAmplify_TiS_intensity(J_s,lm_s,Dtau,J_p,lm_p,L)
physics_constant

% J_s=6e-3/1e-4;
% J_p=1.29/1e-4;
% L=2.5e-2;
% Dtau=200e-15;

% lm_s=800e-9;
% lm_p=532e-9;

Dt=Dtau*6;

omega_s=2*pi*c/lm_s;
omega_p=2*pi*c/lm_p;

N_s=J_s/hbar/omega_s;
N_e=J_p/hbar/omega_p;

t=linspace(0,Dt,500);
Lx=linspace(0,L,500);
n_0=exp(-(t-Dt/2).^2/Dtau^2);
Delta_0=exp(-Lx/L);

n=N_s*n_0/abs(trapz(t,n_0))/c;
Delta=N_e*Delta_0/abs(trapz(Lx,Delta_0));
[n,Delta,ratio_n]=PumpAmplify_TiS(t,n,Lx,Delta);

Js_out=abs(trapz(t,n))*c*hbar*omega_s;
Jp_out=abs(trapz(Lx,Delta))*hbar*omega_p;


end



%{
+[M函数](,PumpAmplify_TiS_intensity)
%}