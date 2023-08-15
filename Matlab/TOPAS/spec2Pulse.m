%{
+[返回目录]
地址::Matlab\TOPAS\spec2Pulse.m
+[保存文本](,频谱转波形)
+[matlabStart](,Matlab)

fft_x::C:\Users\cheng\Documents\MATLAB\fft_x.m
ifft_k::C:\Users\cheng\Documents\MATLAB\ifft_k.m
+[打开](,ifft_k)

测试1:...
测试2:...
+[M函数](,测试1)
+[M函数](,测试2)
+[M函数](,频谱转波形)
%}

function [t,pulse]=spec2Pulse(lambda,inty,phase,t0)

% lambda to omega
[w,inty_w]=wl_transform(lambda,inty);
f0=sqrt(inty_w);
f0=f0.*phase;
%f0=inty_w;

% extend the spectrum
dw=w(2)-w(1);
w0=(dw+mod(w(1),dw)):dw:w(1)-dw;
w=[w0,w];
f0=[zeros(size(w0)),f0];
f=f0.*exp(-1i*t0*w);
[t,pulse]=ifft_k(w,f);

end
