%% 20221118
%% from 文档\物理问题\CBS.ftxt
%{
地址::Matlab\CBS\CBS_rate.m
+[保存M函数](,CBS_rate)
%}

function rate=CBS_rate(P_1,K_1,n_p,dt)
physics_constant;

beta_r=P_1(2:end);
beta_r=beta_r/norm(beta_r);
gamma=P_1(1)/m_e/c;
beta0=sqrt(1-1/gamma^2);

P_12=Lorentz_T2(P_1,beta0,beta_r);
K_12=Lorentz_T2(K_1,beta0,beta_r);

omega_12=K_12(1)*c;
n_p2=n_p*K_12(1)/K_1(1);
dt2=dt/gamma;
sigma=ComptonCrossSection_KN_total(omega_12);
rate=n_p2*sigma*dt2*c;

end



