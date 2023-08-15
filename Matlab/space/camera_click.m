%{
+[M函数](,camera_click)
地址::Matlab\space\camera_click.m

+[保存文本](,camera_click)

%}

function [x2,y2]=camera_click(r0,Eulers,D,X,Y,Z)

% object
%X;
%Y;
%Z;
% camera
%r0=[0,1,-1];
%p0=[0,0,0];
%theta=60;
%D=1;
%Eulers=camera_lookat(r0,p0,theta);


alpha=Eulers(1);
beta=Eulers(2);
gamma=Eulers(3);

vx=[
-sind(gamma)*sind(alpha)*cosd(beta)+cosd(gamma)*cosd(alpha)
sind(gamma)*cosd(alpha)*cosd(beta)+cosd(gamma)*sind(alpha)
sind(gamma)*sind(beta)]';

vy=[
-cosd(gamma)*sind(alpha)*cosd(beta)-sind(gamma)*cosd(alpha)
cosd(gamma)*cosd(alpha)*cosd(beta)-sind(gamma)*sind(alpha)
cosd(gamma)*sind(beta)]';

vz=[
sind(alpha)*sind(beta)
-cosd(alpha)*sind(beta)
cosd(beta)]';

DX=X-r0(1);
DY=Y-r0(2);
DZ=Z-r0(3);

X1=vx(1)*DX+vx(2)*DY+vx(3)*DZ;
Y1=vy(1)*DX+vy(2)*DY+vy(3)*DZ;
Z1=vz(1)*DX+vz(2)*DY+vz(3)*DZ;

x2=X1./Z1*D;
y2=Y1./Z1*D;

end

%{
+[M函数](,拍照)
%}