%% 20221103
%% from 文档\S应用\人体模型.ftxt
%{
+[返回目录](,Eulers)
地址::Matlab\space\vec2Eulers.m
+[保存M函数](,vec2Eulers)
%}


function Eulers=vec2Eulers(x0,y0,z0)
x=x0./sqrt(x0.^2+y0.^2+z0.^2);
y=y0./sqrt(x0.^2+y0.^2+z0.^2);
z=z0./sqrt(x0.^2+y0.^2+z0.^2);
beta=acosd(z);
alpha=sign(x./sind(beta)).*acosd(-y./sind(beta));
gamma=zeros(size(z));

Eulers=[alpha,beta,gamma];
end





