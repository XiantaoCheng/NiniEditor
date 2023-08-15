%% 20221119
%% from 文档\物理问题\CBS.ftxt
%{
地址::Matlab\CBS\Gaussian_mirror_field.m
+[保存M函数](,Gaussian_mirror_field)

测试:...
%}

function [In,In_1,In_2,X_12,Y_12,X_22,Y_22,I]=Gaussian_mirror_field(X,Y,t,E_pulse,lmbd_1,w_0,Dtau,pt_p,angle_p,pt_0,angle_0)

physics_constant;

x_0=pt_0(1);
y_0=pt_0(2);

% Gaussian beam
z_R=w_0.^(2).*pi./lmbd_1;
I_0=(2.*E_pulse)./(sqrt(pi).*pi.*w_0.^(2).*Dtau);
w=@(z)w_0.*sqrt(1+(z./z_R).^(2));
I=@(r,z,t)I_0.*(w_0.^(2))./(w(z).^(2)).*exp(-(2.*r.^(2))./(w(z).^(2))).*exp(-((t-z./c).^(2))./(Dtau.^(2)));

[X_1,Y_1,X_2,Y_2]=transform_2D_reflection_inv(X,Y,angle_0,x_0,y_0);
X_12=X_1*cosd(angle_p)+Y_1*sind(angle_p);
Y_12=Y_1*cosd(angle_p)-X_1*sind(angle_p);
X_22=X_2*cosd(angle_p)+Y_2*sind(angle_p);
Y_22=Y_2*cosd(angle_p)-X_2*sind(angle_p);

In_1=I(Y_12,X_12,t);
In_2=I(Y_22,X_22,t);
In=In_1+In_2;

In_2(isnan(In_2))=0;

end

