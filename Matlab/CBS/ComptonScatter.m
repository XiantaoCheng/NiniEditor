%% 20221113
%% from 文档\物理问题\CBS.ftxt
%{
+[保存M函数](,ComptonScatter)
地址::Matlab\CBS\ComptonScatter.m

测试:...
%}

function [P_2,K_2]=ComptonScatter(K_1,angle_c)
physics_constant;

% beta0=0.1;
% beta_r=[1,0,0];

% lmbd_1=900e-9;
% angle_c=-95;

% p_1r=[1,0.1];
% k_1r=[-2,-0.3];
% p_1r=p_1r/norm(p_1r);
% k_1r=k_1r/norm(k_1r);

% omega_1=2*pi*c/lmbd_1;
% k_1=k_1r*omega_1/c;

omega_1=K_1(1)*c;
k_1=K_1(2:end);
k_1r=k_1/norm(k_1);

k_2r=zeros(size(k_1r));
k_2r(1)=k_1r(1)*cosd(angle_c)+k_1r(2)*sind(angle_c);
k_2r(2)=k_1r(2)*cosd(angle_c)-k_1r(1)*sind(angle_c);

omega_2=(omega_1.*m_e.*c.^(2))./(m_e.*c.^(2)+hbar.*omega_1.*(1-cosd(angle_c)));
k_2=k_2r*omega_2/c;
DE=hbar*omega_1-hbar*omega_2;
E_2=m_e*c^2+DE;
p_2=hbar*k_1-hbar*k_2;

K_2=[omega_2/c,k_2];
P_2=[E_2/c,p_2];

end

%{
lmbd_2=2*pi*c/omega_2;
lmbd_2-lmbd_0
DE/e
+[M函数](,测试公式)
%}

