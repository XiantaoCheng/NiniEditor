%% 20230522
%% from 文档\物理问题\plasma.ftxt
%{
创建"Matlab\plasma"
地址::Matlab\plasma\plasma_refractive_index.m

plasma_refractive_index1:...
(zero版本)
plasma_refractive_index2:...
(忘了加平面光洛伦兹力的版本)

测试:...
+[M函数](,测试)
+[保存M函数](,plasma_refractive_index)
%}

function [n_out,E1,E2]=plasma_refractive_index(lm_0,k_r,n_e,gamma,beta_r,B0)
physics_constant;
addpath('Matlab/funcs');

%lm_0=800e-9;
%k_r=[0,0,1];
%n_e=1e26;
%gamma=2;
%beta_r=[0,1,0];
%B0=[0,0,0];

B_x=B0(1);
B_y=B0(2);
B_z=B0(3);

k=2*pi/lm_0;
omega=2*pi*c/lm_0;
k_0=k_r/norm(k_r);

beta0=(sqrt(gamma.^(2)-1))./(gamma);
beta=beta0*beta_r/norm(beta_r);

B=[0,-B_z,B_y;
B_z,0,-B_x;
-B_y,B_x,0];
M=gamma.*m_e.*(eye(3)+gamma.^(2).*beta'*beta);
% chi_plasma=(n_e.*e.^(2))./(epsilon_0.*omega).*(-M.*omega+1i.*e.*B)^(-1);

C=eye(3)+(beta*k_0')-beta'*k_0;
chi_plasma=(n_e.*e.^(2))./(epsilon_0.*omega).*(-M.*omega+1i.*e.*B)^(-1)*C;
A=(eye(3)-k_0'*k_0)/(eye(3)+chi_plasma);

values=eig(A)';
[vec,~]=eig(A);
result=sortrows([values;vec]')';

n1=sqrt(1/result(1,2));
n2=sqrt(1/result(1,3));
n_out=[n1,n2];

E1=result(2:end,2);
E2=result(2:end,3);

end


%{
+[M函数](,验证公式)
%}

