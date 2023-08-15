%% 20220416
%% from 文档\物理问题\电子能谱.ftxt
%{
(注意, trajectory_fiducial的B为负数的话, 就不互逆了)
Nini, 打开能谱仪原理的trajectory_uniform(节点)

+[M函数](,trajectory_fiducial)
记住trajectory_fiducial(节点)
Nini, 能谱仪原理的trajectory_fiducial是什么?
这个函数是给定发射角和fiducial位置, 确定轨迹

地址::Matlab\spectrometer\trajectory_fiducial.m
+[保存M函数](,trajectory_fiducial)

互逆测试:...
互逆测试2:...
(-B0不互逆...为什么?!)
%}

function E=trajectory_fiducial(x_f,y_f,xs,ys,theta_e,pos_m,siz_m,B,pos_p,theta_p)

physics_constant;

%{
addpath('Matlab\spectrometer');
% electron
xs=0;
ys=0;
theta_e=1;

% magnet
pos_m=[5,0];
siz_m=[5,5];
B=1.2;

% fiducial
y_f=-2:-1:-4;
x_f=25*ones(size(y_f));

% IP
pos_p=[40,0];
theta_p=10;
%}

x_1m=pos_m(1)-siz_m(1)/2;
x_2m=pos_m(1)+siz_m(1)/2;
D=siz_m(1);

y_1m=ys+tan(theta_e).*(x_1m-xs);
Dy_i=D*tan(theta_e);

y_2m=y_1m+Dy_i;
A=(y_2m-y_f)./(x_2m-x_f);
alpha=atan(A);


for i=1:25
    y_2m=y_1m+Dy_i;
    A=(y_2m-y_f)./(x_2m-x_f);
    alpha_i=atan(A);
    R_i=D./(sin(theta_e)-sin(alpha_i));
    beta_i=asin(sin(theta_e)-D./R_i);
    Dy_i=R_i.*(cos(beta_i)-cos(theta_e));
end
R=R_i;

E=sqrt(R.^2*B^2*c^2*e^2+me^2*c^4);

if B>0
    E(alpha>theta_e)=nan;
else
    E(alpha<theta_e)=nan;
end

end

%{
+[M函数](,trajectory_fiducial)
+[保存M函数](,trajectory_fiducial)
%}

