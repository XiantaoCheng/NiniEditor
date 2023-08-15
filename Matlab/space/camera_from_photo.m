%% 20230313
%% from 文档\S应用\照片测量.ftxt
%{
+[返回目录](,camera_from_photo)
+[M函数](,camera_from_photo)
地址::Matlab\space\camera_from_photo.m
+[保存M函数](,camera_from_photo)

测试代码(M函数):...
%}

function [Eulers,r0,S]=camera_from_photo(x,y,L,type)

%L=1;
%x=[1.3875   -2.2156    1.0902    5.9724];
%y=[-1.6881   -2.5159   -9.0195   -7.2663];

%if type~=1
%x=[x(4),x(1),x(2),x(3)];
%y=[y(4),y(1),y(2),y(3)];
%end
if length(x)==4
    x(5)=x(1);
end
if length(y)==4
    y(5)=y(1);
end

[x01,y01]=intersection_lines(x([1,2]),y([1,2]),x([4,3]),y([4,3]));
[x02,y02]=intersection_lines(x([4,5]),y([4,5]),x([2,3]),y([2,3]));

v=[x01,y01];
u=[x02,y02];

A=u(2)-v(2);
B=v(1)-u(1);
C=u(1)*v(2)-u(2)*v(1);

gamma=sign(A)*acosd(B/sqrt(A^2+B^2));
T=[cosd(gamma),-sind(gamma);sind(gamma),cosd(gamma)];
u1=T*u';
v1=T*v';

S2=-u1(1)*v1(1)-(u1(1)*v1(2)-u1(2)*v1(1))^2/(sum((u1-v1).^2));
S=sqrt(S2);

beta=90-atand(C/S/sqrt(A^2+B^2));
% beta=acotd(C/sqrt(A^2+B^2))+180;
alpha=-atand(sind(beta)/cosd(gamma)*v(1)/S+tand(gamma)*cosd(beta));
Eulers=[alpha,beta,gamma];

t1=(v(1)-x(1,2))/(x(1,1)-x(1,2))*L/sqrt(v(1)^2/S^2+v(2)^2/S^2+1);
r1=-[x(1,1)/S,y(1,1)/S,1]*t1;



xhat=[
-sind(gamma)*sind(alpha)*cosd(beta)+cosd(gamma)*cosd(alpha),
-cosd(gamma)*sind(alpha)*cosd(beta)-sind(gamma)*cosd(alpha),
sind(alpha)*sind(beta)]';

yhat=[
sind(gamma)*cosd(alpha)*cosd(beta)+cosd(gamma)*sind(alpha),
cosd(gamma)*cosd(alpha)*cosd(beta)-sind(gamma)*sind(alpha),
-cosd(alpha)*sind(beta)]';

zhat=[
sind(gamma)*sind(beta),
cosd(gamma)*sind(beta),
cosd(beta)]';

r0=[r1*xhat',r1*yhat',r1*zhat'];

%Eulers,r0,S
end

%{
+[M函数](,测试公式)
%}

