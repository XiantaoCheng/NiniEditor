%% 20230218
%% from 文档\物理问题\电透镜.ftxt
%{
地址::Matlab/SEM/lenses_traj.m
+[保存M函数](,lenses_traj)
测试:...
%}

function [zs,rs]=lenses_traj(z0,r0,an0,U0,D,U,Z)

Ts=@(V_1,V_2,d)[1,d;0,1];

zs=[z0];
rs=[r0];

z=z0;
r=r0;
an=an0;

for i=1:length(Z)
[L,L1,L2]=lens_matrix(D(i),U(i),U0);

r1=r+(Z(i)-z).*an;

zs=[zs;Z(i)*ones(size(z))];
rs=[rs;r1];
z=Z(i)*ones(size(z));
r=r1;

r2=L2(1,1)*r+L2(1,2)*an*sqrt(U0);
r3=L(1,1)*r+L(1,2)*an*sqrt(U0);
an3=(L(2,1)*r+L(2,2)*an*sqrt(U0))/sqrt(U0);

zs=[zs;z+D(i)/2;z+D(i)];
rs=[rs;r2;r3];
z=z+D(i);
r=r3;
an=an3;

end

end

%{
+[M函数](,验证公式)
%}

