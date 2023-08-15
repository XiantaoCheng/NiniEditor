%% 20220406
%% from 文档\实验室问题\TOPAS模拟.ftxt
%{
地址::Matlab\TOPAS\TOPAS_1st_pump.m
+[修改标题]"TOPAS_1st_pump"(,扫参数)
生成TOPAS_1st_pump的代码(M函数)
+[保存M函数](,TOPAS_1st_pump)


传播公式(html):...
保存:...
测试:...

TOPAS_1st_pump1(M函数):...
%}

function [d,z_f,Z,R]=TOPAS_1st_pump(D0,f0,dz2,dz5)
addpath('Matlab\optics');
lm=800e-9;

% f0=inf*1e-3;
% D0=10.5*1e-3;

z0=[0,0]*1e-3;
z1=[158.75, 0.0]*1e-3;
z2=[222.25, 0.0]*1e-3+[dz2,0];
z3=[336.55, 0.0]*1e-3;
z5=[626.725, 0.0]*1e-3+[dz5,0];
z_f=[846.725, 0.0]*1e-3;

f1=150*1e-3;
f2=-80*1e-3;
f3=200*1e-3;
f5=40*1e-3;

r=D0/2;
v=f0;

Z=[z0(1)];
R=[r];
% propangation
% L1
u=z1(1)-(v+z0(1));
v=1/(1/f1-1/u);
r=r/(1-(z1(1)-z0(1))/u);
Z(end+1)=z1(1);
R(end+1)=r;

% L2
u=z2(1)-(v+z1(1));
v=1/(1/f2-1/u);
r=r/(1-(z2(1)-z1(1))/u);
Z(end+1)=z2(1);
R(end+1)=r;

% L3
u=z3(1)-(v+z2(1));
v=1/(1/f3-1/u);
r=r/(1-(z3(1)-z2(1))/u);
Z(end+1)=z3(1);
R(end+1)=r;

% L5
u=z5(1)-(v+z3(1));
v=1/(1/f5-1/u);
r=r/(1-(z5(1)-z3(1))/u);
Z(end+1)=z5(1);
R(end+1)=r;

% NC1
u_f=z_f(1)-(v+z5(1));
r_f=r/(1-(z_f(1)-z5(1))/u_f);
Z(end+1)=z_f(1);
R(end+1)=r_f;


% shape
w=abs(r);
N=v/2/w;
w0=2*N/pi*lm;
d=2*GaussianBeam_w(z_f(1)-z5(1),w0,lm,v);



%figure
%plot(Z,R,Z,-R,z_f(1),d/2,'r*')
%axis equal

end


%{
执行扫参数(M函数)
Nini, 打开高斯光束(文件)
%}

