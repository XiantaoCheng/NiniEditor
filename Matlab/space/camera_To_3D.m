%{
+[M函数](,camera_To_3D)
地址::Matlab\space\camera_To_3D.m
+[保存文本](,camera_To_3D)
%}

function [x,y,z]=camera_To_3D(tx,ty,r1,Eulers,D,r0,ux,uy)
% r1=[-2.907704081479481, -6.024253426461256, -1.139908100021243];
% Eulers=[-27.73232875275092, 50.64828866565346, -0.30776320780374067];
% D=1;

% r0=[0,0,0];
% ux=[1,0,0];
% uy=[0,1,0];

% x2=[1,2,3];
% y2=[1,2,3];

x2=reshape(tx,1,numel(tx));
y2=reshape(ty,1,numel(ty));

[X,Y,Z]=Euler_frame(Eulers(1),Eulers(2),Eulers(3));
Dr=r0-r1;


T11=x2*dot(ux,Z)-D*dot(ux,X);
T12=x2*dot(uy,Z)-D*dot(uy,X);
T21=y2*dot(ux,Z)-D*dot(ux,Y);
T22=y2*dot(uy,Z)-D*dot(uy,Y);

V1=D*dot(Dr,X)-x2*dot(Dr,Z);
V2=D*dot(Dr,Y)-y2*dot(Dr,Z);

Det=T11.*T22-T12.*T21;
a=(T22.*V1-T12.*V2)./Det;
b=(-T21.*V1+T11.*V2)./Det;

x=r0(1)+a*ux(1)+b*uy(1);
y=r0(2)+a*ux(2)+b*uy(2);
z=r0(3)+a*ux(3)+b*uy(3);

x=reshape(x,size(tx,1),size(tx,2));
y=reshape(y,size(tx,1),size(tx,2));
z=reshape(z,size(tx,1),size(tx,2));


end