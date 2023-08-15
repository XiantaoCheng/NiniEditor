%{
地址::MATLAB\OPA\OPA_gain.m
+[保存文本](,OPA_gain)
%}

function gain=OPA_gain(la_3,la_1,d,I3)
physics_constant;

% Type1: ooe

%I3=20e9*1e4;

%la_3=0.8e-6;
%la_1=1.2e-6;
beta=19.9018;
%d=4e-3;

Z=sqrt(epsilon0/mu0);
E3=sqrt(I3/Z);

w_1=2*pi*c/la_1;
w_3=2*pi*c/la_3;
w_2=w_3-w_1;

la_2=2*pi*c/w_2;

alpha=0;

E_e=[1;0;0];
E_o=[0;1;0];

n_1=n_bbo(la_1,alpha,beta,E_o);
n_2=n_bbo(la_2,alpha,beta,E_o);
n_3=n_bbo(la_3,alpha,beta,E_e);

k_1=n_1*w_1/c;
k_2=n_2*w_2/c;
k_3=n_3*w_3/c;

%Dk=k_3-k_1-k_2;
Dk=0;

E_10=1;
E_3=E_e*E3;
X2EE=X_BBO(E_3)
X2=max(eig(X2EE))

g_02=w_1^2*w_2^2/k_1/k_2/c^4*X2;
g=sqrt(g_02-Dk^2);
gain=abs(exp(1i*Dk/2*d)*E_10*(cosh(g*d/2)+1i*Dk/g*sinh(1/2*g*d)))^2;
end