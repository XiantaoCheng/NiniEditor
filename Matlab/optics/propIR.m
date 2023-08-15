%{
地址::Matlab\optics\propIR.m
记住propIR(节点)
+[保存文本](,propIR)
E
%}

function [u2,x,y]=propIR(u1,L,lm,Dz)

[M,N]=size(u1);
dx=L/M;
k=2*pi/lm;

x=-L/2:dx:L/2-dx;
[X,Y]=meshgrid(x,x);

h=1/(1i*lm*Dz)*exp(1i*k/(2*Dz)*(X.^2+Y.^2));
H=fft2(fftshift(h))*dx^2;
U1=fft2(fftshift(u1)); 
U2=H.*U1;
u2=ifftshift(ifft2(U2));

end