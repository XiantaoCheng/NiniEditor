%% 20220821
%% from 文档\物理问题\Boris_pusher.ftxt
%{
地址::Matlab\Smilq.\BorisPusher.m
+[保存M函数](,BorisPusher)

测试_磁场(M函数):...
测试_电场(M函数):...
测试_光波(M函数):...
+[新建阅读窗口](,测试_磁场)
+[M函数](,测试_光波)
%}


function [x_2,y_2,z_2,vx_2,vy_2,vz_2]=BorisPusher(x,y,z,v_x,v_y,v_z,dt,E,B,m_p,q)
physics_constant;

% pt0=[0,0,0];
% E=[1e7,1e7,0];
% B=[0,0,1];
% dt=2e-13;
% v_r=[1,1,0];
% gamma=1.001;

% v_r=v_r/norm(v_r);
% beta=sqrt(1-1./gamma.^2);

if nargin<10
m_p=m_e;
end
if nargin<11
q=-e;
end

beta=sqrt(v_x.^2+v_y.^2+v_z.^2)/c;
gamma=1./sqrt(1-beta.^2);

px_0=gamma*m_p*v_x;
py_0=gamma*m_p*v_y;
pz_0=gamma*m_p*v_z;

dpx_1=q.*E(1)*dt/2;
dpy_1=q.*E(2)*dt/2;
dpz_1=q.*E(3)*dt/2;

px_1=px_0+dpx_1;
py_1=py_0+dpy_1;
pz_1=pz_0+dpz_1;
gamma_1=sqrt(1+(px_1.^2+py_1.^2+pz_1.^2)/(m_p*c)^2);

T=(q.*dt/2)./(gamma_1.*m_p).*B;
T_m=[0,T(3),-T(2)
-T(3),0,T(1)
T(2),-T(1),0];
B_f=((eye(3)-(T*T').*eye(3)+2.*T'*T+2.*T_m))./(1+sum(T.^2));

px_2=B_f(1,1)*px_1+B_f(1,2)*py_1+B_f(1,3)*pz_1+dpx_1;
py_2=B_f(2,1)*px_1+B_f(2,2)*py_1+B_f(2,3)*pz_1+dpy_1;
pz_2=B_f(3,1)*px_1+B_f(3,2)*py_1+B_f(3,3)*pz_1+dpz_1;
gamma_2=sqrt(1+(px_2.^2+py_2.^2+pz_2.^2)/(m_p*c)^2);

vx_2=px_2./gamma_2/m_p;
vy_2=py_2./gamma_2/m_p;
vz_2=pz_2./gamma_2/m_p;

x_2=x+vx_2*dt;
y_2=y+vy_2*dt;
z_2=z+vz_2*dt;
end



%{
+[M函数](,验证公式)
%}

