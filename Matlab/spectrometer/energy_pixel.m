%{
+[M函数](,energy_pixel)
地址::Matlab\spectrometer\energy_pixel.m
+[保存文本](,energy_pixel)

%}


function [L,x_0,y_0,x_1m,y_1m,x_2m,y_2m]=energy_pixel(E,pos_e,theta_e,pos_p,siz_p,theta_p,pos_g,siz_g,pos_m,siz_m,B)
%{
% IP
pos_p=[40,0];
siz_p=[1,40];
theta_p=-20;

% electron
pos_e=[0,0];
theta_e=-1;
E=linspace(5,10,10)*1e9*e;

% gas cell
pos_g=[0,0];
siz_g=[6,2];

% magnet
pos_m=[5,0];
siz_m=[5,5];
B=1.2;
%}
physics_constant;

x_1m=pos_m(1)-siz_m(1)/2;
x_2m=pos_m(1)+siz_m(1)/2;
Dm=siz_m(1);
y_1m=pos_e(2)+tand(theta_e)*(x_1m-pos_e(1));

R=sqrt(E.^2/c^2-me^2*c^2)/e/B;
beta=asind(sind(theta_e)-Dm./R);
y_2m=y_1m+R.*(cosd(beta)-cosd(theta_e));

D1=pos_p(1)*sind(theta_p+90)-pos_p(2)*cosd(theta_p+90);
Dx1=cosd(theta_p+90);
Dy1=sind(theta_p+90);

D2=x_2m.*sind(beta)-y_2m.*cosd(beta);
Dx2=cosd(beta);
Dy2=sind(beta);

x_0=(D1*Dx2-D2*Dx1)./(Dy1*Dx2-Dy2*Dx1);
y_0=(D1*Dy2-D2*Dy1)./(Dy1*Dx2-Dy2*Dx1);

L=-sqrt((x_0-pos_p(1)).^2+(y_0-pos_p(2)).^2).*sign(y_0-pos_p(2));
end

%{
+[M函数](,能谱转换)
+[M函数](,绘制场景)
%}