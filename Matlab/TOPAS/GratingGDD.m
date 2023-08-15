%{
+[返回目录]
地址::Matlab\TOPAS\GratingGDD.m
+[保存文本](,光栅GDD)


%}

function GDD_g=GratingGDD(theta_i,lambda,a1,G)
% G=0.1;
% a1=1200;                                    %1/mm
% lambda=(400:1000)*1e-9;
% theta_i=30;
physics_constant;

d=1e-3/a1;
omega=2*pi*c./lambda;

theta=asind(sind(theta_i)-lambda/d);

d2phidw2=4*pi^2*c*G./cosd(theta)./omega.^3/d^2./(cosd(theta)).^2;
GDD_g=-d2phidw2;

end