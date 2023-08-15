%% 20221113
%% from 文档\物理问题\CBS.ftxt
%{
记住"Matlab"
+[保存M函数](,ComptonBackScatter)
地址::Matlab\CBS\ComptonBackScatter.m

测试:...
保存:...
%}

function [P_2,K_2,P_12,K_12,P_22,K_22]=ComptonBackScatter(P_1,K_1,angle_c)
physics_constant;

beta_r=P_1(2:end);
beta_r=beta_r/norm(beta_r);
gamma=P_1(1)/m_e/c;
beta0=sqrt(1-1/gamma^2);

P_12=Lorentz_T2(P_1,beta0,beta_r);
K_12=Lorentz_T2(K_1,beta0,beta_r);

[P_22,K_22]=ComptonScatter(K_12,angle_c);
P_2=Lorentz_T2(P_22,beta0,-beta_r);
K_2=Lorentz_T2(K_22,beta0,-beta_r);

end

%{
lmbd_2=2*pi*c/omega_2;
lmbd_2-lmbd_0
DE/e
+[M函数](,测试公式)
%}

