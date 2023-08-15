%{
+[返回目录](,显示偏振态)
地址::Matlab\Physics\plotPolarization.m
+[保存文本](,显示偏振态)

+[matlabStart](,Matlab)
+[M函数](,显示偏振态)
%}

function plotPolarization(E0)
%E0=[1;-1*exp(-1i*pi/3)];

phi=linspace(0,2*pi,1000);

x=real(E0(1)*exp(-1i*phi));
y=real(E0(2)*exp(-1i*phi));

dx=diff(x);
dy=diff(y);
quiver(x(1:end-1),y(1:end-1),dx,dy);
end