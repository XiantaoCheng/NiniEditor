%{
+[返回目录](,气阀和光束)
+[M函数](,Nozzle_output)
地址::Matlab\nozzle\Nozzle_output.m
+[保存文本](,Nozzle_output)
%}


function n=Nozzle_output(x,y,z,L1,L2,enter_d,throat_d,exit_d,gamma,m,T0,P0,P)
physics_constant;

% P=3;
% gas input
% gamma=5/3;
% m=4*mp;
% T0=300;
% P0=40e5;

% nozzle inputs
% L1=1e-3;
% enter_d=1e-3;
% L2=3e-3;
% throat_d=0.5e-3;
% exit_d=4e-3;
L=L1+L2;

% location
% x0=linspace(-10e-3,10e-3,200);
% z0=linspace(0e-3,10e-3,200);

% [x,z]=meshgrid(x0,z0);
% y=0*ones(size(x));



% gas density
B=throat_d;
C=exit_d;
k=(C-B)/L2/2;

r=k*z+C/2;
S=pi*r.^2;
Sm=pi*(B/2)^2;

cp=gamma/(gamma-1)*kB;
n0=P0/kB/T0;

M2=linspace(1,50,1000);
f2=(1+(gamma-1)/(gamma+1)*(M2.^2-1)).^((gamma+1)/2/(gamma-1))./M2;
M=interp1(f2,M2,S/Sm,'spline');

T=2*T0./(2+(gamma-1)*M.^2);
n=n0*(T/T0).^(1/(gamma-1));

R=sqrt(x.^2+y.^2);
n=n.*exp(-(R.^2./r.^2/2).^P);

end


%{
+[M函数](,密度分布)
%}