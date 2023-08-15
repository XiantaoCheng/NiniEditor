%{
+[返回目录]
地址::Matlab\TOPAS\pulse2Spec.m
+[保存文本](,波形转频谱)
+[matlabStart](,Matlab)

fft_x::C:\Users\cheng\Documents\MATLAB\fft_x.m
ifft_k::C:\Users\cheng\Documents\MATLAB\ifft_k.m
+[打开](,ifft_k)

测试:...
+[M函数](,波形转频谱)
%}

function [lambda,inty,phase]=pulse2Spec(t,pulse)

[w,spec]=fft_x(t,pulse);
inty_w=spec.^2;
[lambda,inty_l]=wl_transform(w,inty_w);

inty=abs(inty_l);
phase=inty_l./abs(inty_l);

end