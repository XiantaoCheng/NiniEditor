%{
+[返回目录](,折射率)
+[M函数](,折射率)

地址::Matlab\Physics\re_electron_index.m
+[保存文本](,折射率)
%}

function [n1,n2,E1,E2]=re_electron_index(k0,gamma,omega,n_e,c,e,epsilon0,me)

%k0=[2,1,1];
%gamma=10;
%omega=1;
%n_e=1;

%physics_constant;
%c=1;
%e=1;
%epsilon0=1;
%me=1;


beta_z=sqrt(1-1/gamma^2);

Ki=-n_e*e^2/gamma/me/epsilon0/omega^2*...
[1-k0(3)*beta_z, 0, k0(1)*beta_z;
 0, 1-k0(3)*beta_z, k0(2)*beta_z;
 0,              0, 1/gamma^2];


A=(eye(3)-k0'*k0/norm(k0)^2)/(eye(3)+Ki);

values=eig(A)';
[vec,~]=eig(A);
result=sortrows([values;vec]')';

n1=1/result(1,2);
n2=1/result(1,3);

E1=result(2:end,2);
E2=result(2:end,3);

end