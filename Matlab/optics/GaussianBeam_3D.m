%% 20220804
%% from 文档\物理问题\高斯光束.ftxt
%{
+[返回目录](,GaussianBeam_3D)
+[M函数](,GaussianBeam_3D)
地址::Matlab\optics\GaussianBeam_3D.m
+[保存M函数](,GaussianBeam_3D)

测试(M函数):...
+[M函数](,测试)
%}

function E=GaussianBeam_3D(X0,Y0,Z0,orig,k_0,lm,w0,E0,n)

% orig=[0.7,0.6,0];
% k_0=[1,4,0];
% lm=400e-9;
% w0=20e-2;
% E0=1;
% n=1;
% N=100;

% x0=linspace(0,1,N);
% y0=linspace(0,1,N);
% [X0,Y0]=meshgrid(x0,y0);
% Z0=zeros(size(X0));

DX0=X0-orig(1);
DY0=Y0-orig(2);
DZ0=Z0-orig(3);

k=k_0/norm(k_0);
Z=k(1)*DX0+k(2)*DY0+k(3)*DZ0;
DX=DX0-Z*k(1);
DY=DY0-Z*k(2);
DZ=DZ0-Z*k(3);
R=sqrt(DX.^2+DY.^2+DZ.^2);

E=GaussianBeam(Z,R,lm,w0,E0,n);

end

%{
+[M函数](,任意方向高斯光束)
%}

