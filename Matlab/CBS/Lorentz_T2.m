%% 20221113
%% from 文档\物理问题\CBS.ftxt
%{
+[保存M函数](,Lorentz_T2)
地址::Matlab\CBS\Lorentz_T2.m
%}

function [F2,T]=Lorentz_T2(F,beta0,beta_r)
physics_constant;

% beta0=0.9;
% beta_r=[1,1,0];
beta=beta0*beta_r/norm(beta_r);
gamma=1/sqrt(1-beta0^2);

Ft=F(1);
Fx=F(2);
Fy=F(3);
Fz=F(4);

v=beta0*c;
v_x=beta(1)*c;
v_y=beta(2)*c;
v_z=beta(3)*c;

T=[gamma,-gamma.*v_x./c,-gamma.*v_y./c,-gamma.*v_z./c;-gamma.*v_x./c,1+(gamma-1).*(v_x.^(2))./(v.^(2)),(gamma-1).*(v_x.*v_y)./(v.^(2)),(gamma-1).*(v_x.*v_z)./(v.^(2));-gamma.*v_y./c,(gamma-1).*(v_y.*v_x)./(v.^(2)),1+(gamma-1).*(v_y.^(2))./(v.^(2)),(gamma-1).*(v_y.*v_z)./(v.^(2));-gamma.*v_z./c,(gamma-1).*(v_z.*v_x)./(v.^(2)),(gamma-1).*(v_z.*v_y)./(v.^(2)),1+(gamma-1).*(v_z.^(2))./(v.^(2))];

Ft2=T(1,1)*Ft+T(1,2)*Fx+T(1,3)*Fy+T(1,4)*Fz;
Fx2=T(2,1)*Ft+T(2,2)*Fx+T(2,3)*Fy+T(2,4)*Fz;
Fy2=T(3,1)*Ft+T(3,2)*Fx+T(3,3)*Fy+T(3,4)*Fz;
Fz2=T(4,1)*Ft+T(4,2)*Fx+T(4,3)*Fy+T(4,4)*Fz;

F2=[Ft2,Fx2,Fy2,Fz2];
F2=reshape(F2,size(F));

end





