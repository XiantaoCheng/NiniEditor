%% 20220805
%% from 文档\物理问题\计算波前.ftxt
%{
+[M函数](,WavefrontPropagation)
地址::Matlab\optics\WavefrontPropagation.m
+[保存M函数](,WavefrontPropagation)
记住WavefrontPropagation(节点)
%}

function E=WavefrontPropagation(X,Y,Z,E0,X0,Y0,Z0,lm,dx,dy)

physics_constant;

if nargin<9
    dx=1;
end
if nargin<10
    dy=1;
end

x=reshape(X,1,numel(X));
y=reshape(Y,1,numel(Y));
z=reshape(Z,1,numel(Z));
E=zeros(size(x));

k=2*pi/lm;

for i=1:length(x)
    DR=sqrt((x(i)-X0).^2+(y(i)-Y0).^2+(z(i)-Z0).^2);
    Ktheta=abs(z(i)-Z0)./DR;

    dE=1i*k/2/pi*E0.*exp(-1i*k*DR).*(1+1i/k./DR).*Ktheta;
    E(i)=sum(sum(dE))*dx*dy;
end

E=reshape(E,size(X));

end





