%% 20220406
%% from 文档\S应用\Hussar.ftxt
%{
地址::Matlab\OPA\OPA_gain_paper.m
+[保存M函数](,OPA_gain_paper)

Nini, 打开Hussar的n_bbo2(节点)
Nini, 打开Hussar的X_BBO(节点)
Nini, 打开BBO相位匹配的二维匹配图(节点)
Nini, 打开BBO相位匹配的BBO_Dk(节点)

OPA_gain_paper1:...
测试:...
+[M函数](,测试)
%}


function [I_1,I_2]=OPA_gain_paper(la_1,I_10,la_3,I_3,alpha,beta,z,BBO_type)
%eoo
if nargin<8
    BBO_type='eoo';
end

addpath('Matlab\OPA');
physics_constant;
c_0=c;

omega_1=2*pi*c/la_1;
omega_3=2*pi*c/la_3;
omega_2=omega_3-omega_1;

la_2=2*pi*c/omega_2;

[Delta,k_3,k_1,k_2,E_p]=BBO_Dk(la_3,la_1,la_2,beta,BBO_type);

Z=sqrt(epsilon0/mu0);
E3=sqrt(I_3/Z);
% E_3=E_p*E3;
X2EE=X_BBO(E_p);
X2=max(eig(X2EE))*E3.^2;


% Gamma=sqrt((2.*omega_2.*omega_1.*d_f.^(2))./(c_0.^(2).*epsilon_0.*n_1.*n_2.*n_3).*I_3);
Gamma=sqrt(omega_1^2*omega_2^2/k_1/k_2/c^4.*X2)/2;
g=sqrt(Gamma.^(2)-(Delta.^(2))./(4));


I_2=I_10.*(omega_2)./(omega_1).*((Gamma)./(g).*sinh(g.*z)).^(2);
I_1=I_10.*(1+((Gamma)./(g).*sinh(g.*z)).^(2));

end

%{

%}

