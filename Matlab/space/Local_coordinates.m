%% 20220622
%% from 文档\数学问题\平面投影.ftxt
%{
+[M函数](,Local_coordinates)
地址::Matlab\space\Local_coordinates.m
+[保存M函数](,Local_coordinates)
%}

function [xo,yo,zo]=Local_coordinates(x,y,z,pt,Eulers)
%Eulers=[0,90,0];
%x=0;
%y=0;
%z=1;
%pt=[0,0,0];

x1=reshape(x,1,numel(x));
y1=reshape(y,1,numel(y));
z1=reshape(z,1,numel(z));

alpha=Eulers(1);
beta=Eulers(2);
gamma=Eulers(3);

vX=[
-sind(gamma)*sind(alpha)*cosd(beta)+cosd(gamma)*cosd(alpha),
sind(gamma)*cosd(alpha)*cosd(beta)+cosd(gamma)*sind(alpha),
sind(gamma)*sind(beta)];

vY=[
-cosd(gamma)*sind(alpha)*cosd(beta)-sind(gamma)*cosd(alpha),
cosd(gamma)*cosd(alpha)*cosd(beta)-sind(gamma)*sind(alpha),
cosd(gamma)*sind(beta)];

vZ=[
sind(alpha)*sind(beta),
-cosd(alpha)*sind(beta),
cosd(beta)];

x2=(x1-pt(1))*vX(1)+(y1-pt(2))*vX(2)+(z1-pt(3))*vX(3);
y2=(x1-pt(1))*vY(1)+(y1-pt(2))*vY(2)+(z1-pt(3))*vY(3);
z2=(x1-pt(1))*vZ(1)+(y1-pt(2))*vZ(2)+(z1-pt(3))*vZ(3);

xo=reshape(x2,size(x));
yo=reshape(y2,size(y));
zo=reshape(z2,size(z));

end

%{
+[M函数](,测试公式)
%}

