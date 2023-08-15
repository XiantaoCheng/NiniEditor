%% 20230204
%% from 文档\数学问题\三维旋转.ftxt
%{
+[M函数](,rotation_3D)
地址::Matlab\space\rotation_3D.m
+[保存M函数](,rotation_3D)
%}

function [X1,Y1,Z1]=rotation_3D(X,Y,Z,zu,theta)

% X=[-1,1,1,-1];
% Y=[0,0,0,0];
% Z=[-1,-1,1,1];

% zu=[0,1,0];
% theta=10;

L=sqrt(zu(1)^2+zu(2)^2);
if L==0
    alpha=0;
elseif zu(1)==0
    alpha=acosd(-zu(1)/L);
else
    alpha=sign(zu(1))*acosd(-zu(1)/L);
end

beta=acosd(zu(3)/norm(zu));

T=[cosd(alpha), -sind(alpha)*cosd(beta), sind(alpha)*sind(beta)
sind(alpha), cosd(alpha)*cosd(beta), -cosd(alpha)*sind(beta)
0, sind(beta), cosd(beta)
]^-1;

Theta=[cosd(theta), -sind(theta), 0;
sind(theta), cosd(theta), 0;
0,0,1];

R=T^-1*Theta*T;
% R=Theta;


X1=R(1,1)*X+R(1,2)*Y+R(1,3)*Z;
Y1=R(2,1)*X+R(2,2)*Y+R(2,3)*Z;
Z1=R(3,1)*X+R(3,2)*Y+R(3,3)*Z;

% patch(X,Y,Z,0);
% view(45,45)
end

%{
+[M函数](,rotation_3D)
+[保存文本](,rotation_3D)
%}

