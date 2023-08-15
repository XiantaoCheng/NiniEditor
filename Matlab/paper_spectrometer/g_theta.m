%{
地址::Matlab\paper_spectrometer\g_theta.m
+[保存文本](,g_theta)
+[M函数](,g_theta)

Nini, 打开函数拟合(文件)
%}

function [g,sigma]=g_theta(E_0)
% E_0[GeV]
% sigma[rad]
A_1=3.3542;
A_0=0.0909;
sigma=A_1./E_0+A_0;
sigma=sigma*1e-3;

As=[-0.00458499383846668 0.0349842090102828 3.4212470979214 0.00492462428610245];
sigma=As(1)/E_0.^3+As(2)/E_0.^2+As(3)/E_0+As(4);
sigma=sigma*1e-3;

A=1/sqrt(pi)/sigma;
g=@(theta)A*exp(-theta.^2/sigma.^2);

end




