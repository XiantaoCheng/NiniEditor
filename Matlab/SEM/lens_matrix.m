%% 20230311
%% from 文档\物理问题\电透镜.ftxt
%{
地址::Matlab/SEM/lens_matrix.m
+[保存M函数](,lens_matrix)
测试:...
%}

function [L,L1,L2,T1,T2]=lens_matrix(D,U,U0)
% D=10e-2;
% U=4000;
% U0=8000;

N=10000;
E1=-(U-U0)/(D/2);
E2=-(U0-U)/(D/2);

Re=@(E_1,E_2,V_0)[1,0;-(E_1-E_2)./(4.*sqrt(V_0)),1];
Ts=@(V_1,V_2,d)[1,(2.*d)./(sqrt(V_1)+sqrt(V_2));0,1];

R1=Re(0,E1,U0);
R2=Re(E1,E2,U);
R3=Re(E2,0,U0);

d=D/2/(N-1);
Ux=linspace(U0,U,N);
T1=eye(2);
for i=1:N-1
    T1=Ts(Ux(i),Ux(i+1),d)*T1;
end

Ux=linspace(U,U0,N);
T2=eye(2);
for i=1:N-1
    T2=Ts(Ux(i),Ux(i+1),d)*T2;
end

L1=R1;
L2=R2*T1*R1;
L=R3*T2*R2*T1*R1;

end

%{
+[M函数](,验证公式)
%}

