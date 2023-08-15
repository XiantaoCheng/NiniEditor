%% 20220602
%% from 文档\物理问题\FROG.ftxt
%{
+[M函数](,验证公式)
地址::Matlab\FROG\FROG_In.m
+[保存M函数](,FROG_In)

测试:...
测试2:...

旧算法:...
(是错的, 用了插值改变了光谱)
测试FROG_In:...
+[新建阅读窗口](,测试FROG_In)
%}

function [I_f,E1,E2,t]=FROG_In(t0,E0,tau,lm)
physics_constant;

[E1,w,t]=pulse_shift(t0,E0,0);
[E2,w]=pulse_shift(t0,E0,tau);
lm_x=2*pi*c./w;

E_s=E1.*E2;
% E_s=E1;
f_E=fft(E_s);
I_f0=abs(f_E).^2;

I_f=interp1(lm_x,I_f0,lm,'spline');
I_f(lm<min(lm_x)|lm>max(lm_x))=0;

end


%{
+[保存M函数](,FROG_In)
%}

