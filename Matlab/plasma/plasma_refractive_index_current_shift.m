%% 20230525
%% from 文档\物理问题\plasma.ftxt
%{
地址::Matlab/plasma/plasma_refractive_index_current_shift.m
+[保存M函数](,plasma_refractive_index_current_shift)
%}

function [Delta_n_r,Delta_n_rp,Delta_n_rB]=plasma_refractive_index_current_shift(lm_0,k_r,n_0,gamma,beta_r,B,n_r)
physics_constant;

q=e;

beta0=(sqrt(gamma.^(2)-1))./(gamma);
beta=beta0*beta_r/norm(beta_r);
J_0=n_0*beta(2)*c*q;

k_0=2*pi/lm_0;
omega_p=sqrt((q.^2.*n_0)./(epsilon_0.*m_e));
omega_B=(q.*B)./(m_e);
omega=2*pi*c/lm_0;
n_e=n_0;


Delta_n_r=n_r.*(omega_p.^2)./(omega.^2).*(J_0)./(q.*n_e.*c);
Delta_n_rp=(beta(2))./(2).*(omega_p.^2)./(omega.^2).*(J_0)./(q.*n_e.*c);
Delta_n_rB=((omega_B./omega)./(2)).*(omega_p.^2)./(omega.^2).*(J_0)./(q.*n_e.*c);


end

%{
+[保存M函数](,plasma_refractive_index_current_shift)
%}

