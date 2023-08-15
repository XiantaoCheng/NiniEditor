%% 20221017
%% from 文档\实验室问题\Dazzler优化.ftxt
%{
地址::Matlab\FROG\spectrum_2_pulse.m
+[保存M函数](,spectrum_2_pulse)
测试:...
%}

function [t,E]=spectrum_2_pulse(lm,In,phi)

physics_constant;
lm_x=lm*1e-9;
w_x=2*pi*c./lm_x;

w=linspace(max(w_x)/length(w_x),max(w_x),length(w_x));
In_w=interp1(w_x,In,w);
phi_w=interp1(w_x,phi,w);

S=sqrt(In_w).*exp(-1i*phi_w);
S(isnan(S))=0;

[t,f]=ifft_k(w,S);
t=t-mean(t);
E=fftshift(f);

end



