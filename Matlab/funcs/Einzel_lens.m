%% 20230115
%% from 文档\物理问题\静电场.ftxt
%{
地址::Matlab\funcs\Einzel_lens.m
+[保存M函数](,验证公式)
+[M函数](,验证公式)
+[打开]"Matlab\funcs"

besseljzero(M函数):...

展开1:...
贝塞尔零点:...
贝塞尔曲线:...
带孔圆盘:...

保存:...
%}


addpath('Matlab\funcs');


x=linspace(0,1,1000);
J_0=@(x)besselj(0,x);
J_1=@(x)besselj(1,x);
I_1=@(x)besseli(0,x);

U0=100;
U1=0;
D=0.4;
a=2;
b=0.4;

u0=besseljzero(0,1:100);

A1=zeros(size(u0));
A2=zeros(size(u0));
for i=1:length(A1)
k_m=u0(i)/a;
A1(i)=(U0*exp(-2*k_m*D)-U1*exp(-k_m*D))./(exp(-2*k_m*D)-1)*2/J_1(u0(i)).^2*trapz(x,x.*J_0(u0(i)*x));
A2(i)=(U1*exp(-k_m*D)-U0)./(exp(-2*k_m*D)-1)*2/J_1(u0(i)).^2*trapz(x,x.*J_0(u0(i)*x));
end

varphi=@(r,z)zeros(size(r));
for i=1:length(A1)
k_m=u0(i)/a;
varphi=@(r,z)varphi(r,z)+J_0(k_m*r).*(A1(i)*exp(k_m*z)+A2(i)*exp(-k_m*z));
end

z=linspace(0,D,100);
B=zeros(1,120);
km=zeros(size(B));
for i=1:length(B)
km(i)=2*(i-1)*pi/L;
B(i)=4/L/I_0(km(i)*b)*trapz(z,varphi(b,z).*cos(km(i)*z));
end
B(1)=B(1)/2;

varphi_2=@(r,z)zeros(size(r));
for i=1:length(B)
varphi_2=@(r,z)varphi_2(r,z)+B(i)*I_0(km(i)*r).*cos(km(i)*z);
end

A3=zeros(size(u0));
r=linspace(0,a,100);
u1=varphi_2(r,D);
u1(r>b)=U1;
for i=1:length(A3)
k_m=u0(i)/a;
A3(i)=2/a^2/J_1(u0(i)).^2*trapz(r,r.*J_0(k_m*r).*u1);
end

varphi_3=@(r,z)zeros(size(r));
for i=1:length(A3)
k_m=u0(i)/a;
varphi_3=@(r,z)varphi_3(r,z)+J_0(k_m*r).*A3(i).*exp(-k_m.*(z-D));
end


r=linspace(-1,1,100)*a;
z=linspace(-1,1,100)*D*2;
[R,Z]=meshgrid(r,z);

u_1=varphi(abs(R),abs(Z));
u_2=varphi_2(abs(R),Z);
u_3=varphi_3(abs(R),abs(Z));
R_abs=abs(R);
Z_abs=abs(Z);

u=u_1;
u(R_abs<b)=u_2(R_abs<b);
u(Z_abs>D)=u_3(Z_abs>D);
contourf(R,Z,u,20)
axis equal

%{
plot(z,varphi(b,z),z,varphi_2(b,z))
+[M函数](,验证公式)
%}

