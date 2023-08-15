%% 20220408
%% from 文档\物理问题\光栅压缩器.ftxt
%{
+[M函数](,grating_compressor_dtau)
地址::Matlab\optics\grating_compressor_dtau.m
+[保存M函数](,grating_compressor_dtau)

测试(M函数):...
%}

function [FWHM1,FWHM2]=grating_compressor_dtau(D,theta,D_0,theta_0,G,lm_0,FWHM)
physics_constant;

%D=0.67;
%theta=47.29;

%D_0=0.67;
%theta_0=47.28;
%G=1480;

%lm_0=800e-9;
%FWHM=66e-15;


d=1e-3/G;
dtau=FWHM/2/sqrt(log(2));

dw=2/dtau;
Dw=40*dw;
n=1;

w_0=2*pi*c./lm_0;
w=linspace(w_0-Dw,w_0+Dw,35000);
lm=2*pi*c./w;

t0=1200e-15;

beta=@(w,theta,n)asind(-sind(theta)+n*2*pi*c./w/d);
l=@(w,D,theta,n)D*((1+sind(beta(w,theta,n))*sind(theta))./cosd(beta(w,theta,n)));
phase=@(w,D,theta,n)w.*D/c.*cosd(beta(w,theta,n));

dphi=@(w,D,theta,n)l(w,D,theta,n)/c;
d2phi=@(w,D,theta,n)-4*n^2*pi^2*c*D./w.^3/d^2./cosd(beta(w,theta,n)).^3;

phase_0=phase(w,D_0,theta_0,n)-phase(w_0,D_0,theta_0,n)-dphi(w_0,D_0,theta_0,n)*(w-w_0);

phase_a=phase(w,D,theta,n);
phase01=phase(w_0,D,theta,n)+dphi(w_0,D,theta,n)*(w-w_0);
phase2=1/2*d2phi(w_0,D,theta,n)*(w-w_0).^2;
phase2_0=1/2*d2phi(w_0,D_0,theta_0,n)*(w-w_0).^2;
phase2_a=phase_a-phase01;

S0=exp(-(w-w_0).^2/dw^2).*exp(-1i*t0*w);

% real
S=S0.*exp(-1i*phase_0);
S=S.*exp(1i*phase2_a);
S(isnan(S))=0;
S(isinf(S))=0;
[t,f]=ifft_k(w,S);

f_abs=abs(f);
f_max=max(f_abs);
Df=f_abs(f_abs>f_max/2);
Dt=t(f_abs>f_max/2);

t01=t(f_abs==f_max);
FWHM1=(max(Dt)-min(Dt));

% 2nd
S2=S0.*exp(-1i*phase2_0);
S2=S2.*exp(1i*phase2);
S2(isnan(S2))=0;
S2(isinf(S2))=0;
[t,f2]=ifft_k(w,S2);

f_abs=abs(f2);
f_max=max(f_abs);
Df2=f_abs(f_abs>f_max/2);
Dt2=t(f_abs>f_max/2);

t02=t(f_abs==f_max);
FWHM2=(max(Dt2)-min(Dt2));

end

%{
+[M函数](,色散曲线)
%}

