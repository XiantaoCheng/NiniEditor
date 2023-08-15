%{
Nini, 打开阴影形状的g_theta(节点)
+[M函数](,IP_ATM)
地址::Matlab\paper_spectrometer\IP_ATM.m
+[保存文本](,IP_ATM)
测试:...
测试散射分布:...
存档:...

IP_ATM1(M函数):...
IP_ATM2(M函数):...
+[新建阅读窗口](,IP_ATM1)
+[保存文本](,IP_ATM)
%}


function [I,I_s,I_0,I0]=IP_ATM(E_0,DE,t_0,Dt,x_o,z_o,B,D,z_m,R,x_f,z_f,x_i,z_i)
%addpath('Matlab\paper_spectrometer');
physics_constant;

dx_i=abs(x_i(2)-x_i(1));

N1=length(x_i);
N2=1000;

Da=0.2*Dt;
g=@(a)exp(-a.^2/Da^2)/sqrt(pi)/Da;
f=@(t)exp(-(t-t_0).^2/Dt^2)/sqrt(pi)/Dt;
S=@(E)exp(-(E-E_0).^2/DE^2);

L=z_i-z_o;
L_0=z_i-z_m;

t=linspace(t_0-Dt*2,t_0+Dt*2,N2);
x_a=x_f;
I0=zeros(1,N1);
I=zeros(1,N1);
I_s=zeros(1,N1);

for i=1:N1
    dEdt=B*e*c*D*L_0*L./(x_i(i)-x_o-t*L).^2;
    E=B*e*c*D*L_0./(x_i(i)-x_o-t*L);
    x=x_i(i)-(z_i-z_f)*((x_i(i)-x_o)/(z_i-z_m)-(z_m-z_o)/(z_i-z_m)*t);
    
    F=dEdt.*S(E).*f(t);
    I0(i)=trapz(t,F);
    F(abs(x-x_f)<R)=0;
    I(i)=trapz(t,F);

    F1=dEdt.*S(E).*f(t);
    F1(abs(x-x_f)>=R)=0;
    
    if sum(abs(F1))~=0
    for j=1:N1
        g=g_theta(mean(E)/e/1e9);

        alpha=(x_i(j))./(z_i-z_f)-(x.*(z_i-z_m))./((z_i-z_f).*(z_f-z_m))+t.*(z_m-z_o)./(z_f-z_m)+(x_o)./(z_f-z_m);
        dalpha=dx_i/(z_i-z_f);
        I_s(j)=I_s(j)+trapz(t,F1.*g(alpha))*dalpha;
    end
end

end
I0=abs(I0);
I_0=I;
I=abs(I+I_s);

end

%{
[g,s]=g_theta(1e9*e/e/1e9)

figure
+[M函数](,验证公式)
figure(2)
plot(x_i,E/e)
plot(x_i,x)
%}