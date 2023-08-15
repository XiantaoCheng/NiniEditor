%{
+[M函数](,坐标变换)
地址::Matlab\space\3D_transform.m
+[保存文本](,坐标变换)
%}

function [x,y,z]=3D_transform(Dr,alpha,beta,gamma,x0,y0,z0)

% Dr=[1,1,1];
% alpha=45;
% beta=45;
% gamma=0; 

vX=[
-sind(gamma)*sind(alpha)*cosd(beta)+cosd(gamma)*cosd(alpha),
sind(gamma)*cosd(alpha)*cosd(beta)+cosd(gamma)*sind(alpha),
sind(gamma)*sind(beta)]';

vY=[
-cosd(gamma)*sind(alpha)*cosd(beta)-sind(gamma)*cosd(alpha),
cosd(gamma)*cosd(alpha)*cosd(beta)-sind(gamma)*sind(alpha),
cosd(gamma)*sind(beta)]';

vZ=[
sind(alpha)*sind(beta),
-cosd(alpha)*sind(beta),
cosd(beta)]';

T=[vX;vY;vZ];

X0=reshape(x0,numel(x0),1);
Y0=reshape(y0,numel(y0),1);
Z0=reshape(z0,numel(z0),1);
P0=[X0,Y0,Z0];

P=P0*T;
x=reshape(P(:,1),size(x0))+Dr(1);
y=reshape(P(:,2),size(y0))+Dr(2);
z=reshape(P(:,3),size(z0))+Dr(3);

end

%{
+[M函数](,显示局域坐标系)
%}