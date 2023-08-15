%% 20230525
%% from 文档\物理问题\plasma.ftxt
%{
地址::Matlab/plasma/plasma_refractive_index_LW.m
+[保存M函数](,plasma_refractive_index_LW)
测试:...

保存:...
%}

function [n_out,E1,E2,E3]=plasma_refractive_index_LW(lm_0,k_r,n_0,gamma,beta_r,type_txt)

physics_constant;

% lm_0=873e-9;
% n_0=1e25;
% k_r=[1,0,0];
% beta_r=[1,3,0];
% gamma=1.2;
% beta0=0.4;

I=eye(3);

q=e;
k=2*pi/lm_0;
omega=2*pi*c/lm_0;
k_0=k_r/norm(k_r);

beta0=(sqrt(gamma.^(2)-1))./(gamma);
% gamma=1/sqrt(1-beta0^2);
beta=beta0*beta_r/norm(beta_r);
M0=gamma.*(I+gamma.^(2).*beta'*beta);
J_0=q*n_0*beta*c;

if strcmp(type_txt,'no flow')
    A=(I-(q.^2.*n_0)./(epsilon_0.*m_e.*omega.^2).*(k_0'*k_0)*M0^-1)^-1*(I-(q.^2.*n_0)./(epsilon_0.*m_e.*omega.^2)*M0^-1);
else
    A=(I-(q.^2.*n_0)./(epsilon_0.*m_e.*omega.^2).*(k_0'*k_0)*M0^-1)^-1*(I-(q.^2.*n_0)./(epsilon_0.*m_e.*omega.^2)*M0^-1-(q)./(epsilon_0.*m_e.*omega.^2*c).*(J_0'*k_0)*M0^-1);
end

values=eig(A)';
[vec,~]=eig(A);
result=sortrows([values;vec]')';

n1=sqrt(result(1,1));
n2=sqrt(result(1,2));
n3=sqrt(result(1,3));
n_out=[n1,n2,n3];

E1=result(2:end,1);
E2=result(2:end,2);
E3=result(2:end,3);


end


%{
+[保存M函数](,plasma_refractive_index_LW)
%}

