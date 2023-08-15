%{
地址::Matlab\optics\propTF.m
记住propTF(节点)
+[保存文本](,propTF)
E
%}

function [u2,x,y]=propIR(u1,L,lm,Dz)

[M,N]=size(u1);
dx=L/M;
k=2*pi/lm;

fx=-1/(2*dx):1/L:1/(2*dx)-1/L;
[FX,FY]=meshgrid(fx,fx); 

H=exp(-j*pi*lm*Dz*(FX.^2+FY.^2));
H=fftshift(H);
U1=fft2(fftshift(u1)); 
U2=H.*U1;
u2=ifftshift(ifft2(U2));

end