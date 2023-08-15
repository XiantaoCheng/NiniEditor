%{
+[返回目录](,Eulers)

地址::Matlab\space\Eulers.m
+[保存文本](,Eulers)
%}

function [alpha,beta,gamma]=Eulers(x0,y0,z0)
x=x0./sqrt(x0.^2+y0.^2+z0.^2);
y=y0./sqrt(x0.^2+y0.^2+z0.^2);
z=z0./sqrt(x0.^2+y0.^2+z0.^2);
beta=acosd(z);
alpha=sign(x./sind(beta)).*acosd(-y./sind(beta));
gamma=zeros(size(z));
end

