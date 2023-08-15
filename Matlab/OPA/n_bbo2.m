%{
地址::MATLAB\OPA\n_bbo2.m
+[保存文本](,n_bbo2)

% 晶轴沿着z轴方向
A=[0,0,1];
B=[0,0,1];

C=cross(A,B)
D=cross(C,B)

测试:...
+[新建阅读窗口](,测试)
%}

function [n_o,n_e,E_o,E_e]=n_bbo2(lm_0,k)

kx=k(1)./norm(k);
ky=k(2)./norm(k);
kz=k(3)./norm(k);

beta=acosd(kz);
alpha=sign_1(ky).*acosd(kx./sqrt(ky.^2+kx.^2));
alpha(isnan(alpha))=0;

E_o=[ky,-kx,0];
if norm(E_o)==0
    E_o=[0,1,0];
else
    E_o=E_o/norm(E_o);
end
E_e=cross(E_o,[0,0,1]);

n_o=n_bbo(lm_0,alpha,beta,E_o');
n_e=n_bbo(lm_0,alpha,beta,E_e');

end

%{
+[保存文本](,n_bbo2)
%}