%% 20230522
%% from 文档\物理问题\plasma.ftxt
%{
地址::Matlab/plasma/plasma_refractive_index_FR.m
+[保存M函数](,plasma_refractive_index_FR)
%}

function [n_out,E1,E2]=plasma_refractive_index_FR(lm_0,n_0,B0)
physics_constant;

q=e;
% n_0=1e25;
% B0=100;
% lm_0=873e-9;

k_0=2*pi/lm_0;
omega_p=sqrt((q.^2.*n_0)./(epsilon_0.*m_e));
omega_B=(q.*B0)./(m_e);
omega=2*pi*c/lm_0;

n_R=sqrt(1-(omega_p.^2./omega.^2)./(1+omega_B./omega));
n_L=sqrt(1-(omega_p.^2./omega.^2)./(1-omega_B./omega));

n_out=[n_R,n_L];
E1=[-1i,-1,0]'/sqrt(2);
E2=[-1i,1,0]'/sqrt(2);
end



