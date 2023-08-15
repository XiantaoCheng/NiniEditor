%% 20220602
%% from 文档\物理问题\FROG.ftxt
%{
地址::Matlab\FROG\pulse_shift.m
+[保存M函数](,pulse_shift)
Nini, 打开词典的计算波包(节点)

+[M函数](,pulse_shift)
算法(H函数):...

测试:...
扫描测试:...
+[M函数](,扫描测试)
保存:...
%}

function [E1,w,t]=pulse_shift(t0,E0,Dt)
% Dt=200e-15;

E_s=E0;
[w,f_E0]=fft_x(t0,E_s);
w=linspace(min(w),4*max(w)+3*min(w),4*length(w));
f_E=[f_E0,zeros(1,3*length(f_E0))];

% shift
S=f_E.*exp(-1i*w*Dt);

[t,f1]=ifft_k(w,S);
% E1=fftshift(f1);
E1=f1;
t=t-mean(t);

end

%{
+[M函数](,pulse_shift)
%}

