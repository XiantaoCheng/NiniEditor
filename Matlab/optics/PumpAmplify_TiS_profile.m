%{
+[M函数](,PumpAmplify_TiS_profile)
地址::Matlab\optics\PumpAmplify_TiS_profile.m
+[保存文本](,PumpAmplify_TiS_profile)
Dx
是([动词库],动词)->+[打开文件](+新窗口,动词)
+[显示](,地址)
%}

function [Js_out,Jp_out]=PumpAmplify_TiS_profile(J_s,lm_s,Dtau,J_p,lm_p,L)
physics_constant

Dt=Dtau*6;

omega_s=2*pi*c/lm_s;
omega_p=2*pi*c/lm_p;

t=linspace(0,Dt,500);
Lx=linspace(0,L,500);
n_0=exp(-(t-Dt/2).^2/Dtau^2);
n_0=n_0/abs(trapz(t,n_0))/c;
Delta_0=exp(-Lx/L);
Delta_0=Delta_0/abs(trapz(Lx,Delta_0));

Js_out=zeros(size(J_s));
Jp_out=zeros(size(J_p));

for i=1:size(J_s,1)
    for j=1:size(J_s,2)
        n=J_s(i,j)/hbar/omega_s*n_0;
        Delta=J_p(i,j)/hbar/omega_p*Delta_0;
        [n,Delta]=PumpAmplify_TiS(t,n,Lx,Delta);
        
        Js_out(i,j)=abs(trapz(t,n))*c*hbar*omega_s;
        Jp_out(i,j)=abs(trapz(Lx,Delta))*hbar*omega_p;
    end
end


end



%{
+[M函数](,PumpAmplify_TiS_profile)
%}