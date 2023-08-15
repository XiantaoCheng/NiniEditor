%% 20230211
%% from 文档\物理问题\静电场.ftxt
%{
地址::Matlab/SEM/Einzel_lens_phi.m
+[保存M函数](,Einzel_lens_phi)


HS_fun(M函数):...
测试:...
%}

function [varphi,varphi_1,varphi_2,varphi_3]=Einzel_lens_phi(U0,H,R0,R1)

% addpath('Matlab\funcs');
addpath('Matlab/funcs');

x=linspace(0,1,1000);
J_0=@(x)besselj(0,x);
J_1=@(x)besselj(1,x);
I_0=@(x)besseli(0,x);

U1=0;
D=H/2;
a=R1;
b=R0;

L=4*D;
u0=besseljzero(0,1:100);

A1=zeros(size(u0));
A2=zeros(size(u0));
for i=1:length(A1)
k_m=u0(i)/a;
A1(i)=(U0*exp(-2*k_m*D)-U1*exp(-k_m*D))./(exp(-2*k_m*D)-1)*2/J_1(u0(i)).^2*trapz(x,x.*J_0(u0(i)*x));
A2(i)=(U1*exp(-k_m*D)-U0)./(exp(-2*k_m*D)-1)*2/J_1(u0(i)).^2*trapz(x,x.*J_0(u0(i)*x));
end

varphi_1=@(r,z)zeros(size(r));
for i=1:length(A1)
k_m=u0(i)/a;
varphi_1=@(r,z)varphi_1(r,z)+J_0(k_m*r).*(A1(i)*exp(k_m*z)+A2(i)*exp(-k_m*z));
end

z=linspace(0,D,100);
B=zeros(1,120);
km=zeros(size(B));
for i=1:length(B)
km(i)=2*(i-1)*pi/L;
B(i)=4/L/I_0(km(i)*b)*trapz(z,varphi_1(b,z).*cos(km(i)*z));
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


%varphi=@(r,z)varphi_1(abs(r),abs(z)).*HS_fun(abs(r)-R0).*HS_fun(D-abs(z))...
%    +varphi_2(abs(r),abs(z)).*HS_fun(R0-abs(r)).*HS_fun(D-abs(z))...
%    +varphi_3(abs(r),abs(z)).*HS_fun(abs(z)-D);

function u=U_phi(r,z)
    u_1=varphi_1(abs(r),abs(z));
    u_2=varphi_2(abs(r),abs(z));
    u_3=varphi_3(abs(r),abs(z));
    
    u=u_1;
    u(abs(r)<R0)=u_2(abs(r)<R0);
    u(abs(z)>D)=u_3(abs(z)>D);
end

varphi=@(r,z)U_phi(r,z);

end



%{
+[保存M函数](,Einzel_lens_phi)
%}

