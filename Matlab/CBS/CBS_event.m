%% 20221119
%% from 文档\物理问题\CBS.ftxt
%{
地址::Matlab\CBS\CBS_event.m
+[保存M函数](,CBS_event)
%}

function [P_2,K_2,rate]=CBS_event(P_1,K_1,n_p,dt)
physics_constant;
addpath('Matlab\random');

theta_p=linspace(0,2*pi,200);

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

if rand()<rate
    dsigma=ComptonCrossSection_KN(omega_12,theta_p);
    theta_r=random_func_1D(1,1,theta_p,dsigma);
    angle_r=theta_r/pi*180;
    
    omega_12=K_12(1)*c;
    dsigma=ComptonCrossSection_KN(omega_12,theta_p);
    theta_r=random_func_1D(1,1,theta_p,dsigma);
    angle_r=theta_r/pi*180;
    [P_22,K_22]=ComptonScatter(K_12,angle_r);
    
    P_2=Lorentz_T2(P_22,beta0,-beta_r);
    K_2=Lorentz_T2(K_22,beta0,-beta_r);
else
    P_2=P_1;
    K_2=[0,0,0,0];
end

end



