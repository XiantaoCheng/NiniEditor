%% 20230311
%% from 文档\物理问题\电透镜.ftxt
%{
地址::Matlab/SEM/test_traj_mat.m
+[保存M函数](,test_traj_mat)
%}

function [zs,rs,ts]=test_traj_mat(z,u_1,r0,theta0)

Re=@(E_1,E_2,En_0)[1,0;-(E_1-E_2)./(4.*sqrt(En_0)),1];
Ts=@(En_1,En_2,d)[1,(2.*d)./(sqrt(En_1)+sqrt(En_2));0,1];

% r0=1;
% theta0=0;

d=(max(z)-min(z))/(length(z)-1);

r=r0;
theta_sqrtV=0;
rs=[];
ts=[];

T0=eye(2);
for i=2:length(z)-2
En_1=(0-u_1(z(i)));
En_2=(0-u_1(z(i+1)));
En_0=(En_1+En_2)/2;

E_1=(u_1(z(i+1))-u_1(z(i-1)))/2/d;
E_2=(u_1(z(i+2))-u_1(z(i)))/2/d;

R1=Re(E_1,E_2,En_0);
T1=Ts(En_1,En_2,d);
T=R1*T1;

T0=T0*T;

r_1=r*T(1,1)+theta_sqrtV*T(1,2);
theta_sV1=r*T(2,1)+theta_sqrtV*T(2,2);
r=r_1;
theta_sqrtV=theta_sV1;

rs(end+1)=r;
ts(end+1)=theta_sqrtV/sqrt(En_0);
end
zs=z(2:end-2);

end

%{
+[保存M函数](,test_u_1)
%}

