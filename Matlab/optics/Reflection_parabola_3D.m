%{
+[返回目录](,Reflection_parabola_3D)
+[M函数](,Reflection_parabola_3D)
地址::Matlab\optics\Reflection_parabola_3D.m

+[保存文本](,Reflection_parabola_3D)

测试(M函数):...
%}
function [xo,yo,zo,vo_x,vo_y,vo_z]=Reflection_parabola_3D(xi,yi,zi,vi_x,vi_y,vi_z,a,r0,Eulers)
% a=1; 
% r0=[0,0,0];

alpha=Eulers(1);
beta=Eulers(2);
gamma=Eulers(3);


%xi=linspace(-1,1,10);
%yi=0*ones(size(xi));
%zi=10*ones(size(xi));

%vi_x=0*ones(size(xi));
%vi_y=1*ones(size(xi));
%vi_z=-1*ones(size(xi));


% local frame
fx=[
-sind(gamma)*sind(alpha)*cosd(beta)+cosd(gamma)*cosd(alpha)
sind(gamma)*cosd(alpha)*cosd(beta)+cosd(gamma)*sind(alpha)
sind(gamma)*sind(beta)]';

fy=[
-cosd(gamma)*sind(alpha)*cosd(beta)-sind(gamma)*cosd(alpha)
cosd(gamma)*cosd(alpha)*cosd(beta)-sind(gamma)*sind(alpha)
cosd(gamma)*sind(beta)]';

fz=[
sind(alpha)*sind(beta)
-cosd(alpha)*sind(beta)
cosd(beta)]';

DX=xi-r0(1);
DY=yi-r0(2);
DZ=zi-r0(3);


x_A=fx(1)*DX+fx(2)*DY+fx(3)*DZ;
y_A=fy(1)*DX+fy(2)*DY+fy(3)*DZ;
z_A=fz(1)*DX+fz(2)*DY+fz(3)*DZ;

v_x=fx(1)*vi_x+fx(2)*vi_y+fx(3)*vi_z;
v_y=fy(1)*vi_x+fy(2)*vi_y+fy(3)*vi_z;
v_z=fz(1)*vi_x+fz(2)*vi_y+fz(3)*vi_z;



judge=4*a.*v_x.^2.*(a*x_A.^2-z_A)./(2*a*v_x.*v_z.*x_A-v_z.^2);

t1=(-(2*a*v_x.*x_A-v_z)+sqrt((2*a*v_x.*x_A-v_z).^2-4*a*v_x.^2.*(a*x_A.^2-z_A)))/2/a./v_x.^2;
% t1(v_x==0)=(a*x_A(v_x==0).^2-z_A(v_x==0))./v_z(v_x==0);
t1(judge<1e-7)=-(a*x_A(judge<1e-7).^2-z_A(judge<1e-7))./(2*a*v_x(judge<1e-7).*x_A(judge<1e-7)-v_z(judge<1e-7));
x_B=t1.*v_x+x_A;
y_B=t1.*v_y+y_A;
z_B=t1.*v_z+z_A;

v_0=sqrt(v_x.^2+v_z.^2);
theta1=sign(v_z).*acosd(v_x./v_0);
theta2=atand(2*a*x_B);
theta3=2*theta2-theta1;

v_x2=cosd(theta3);
v_y2=v_y;
v_z2=sind(theta3);

[xo,yo,zo]=transform_3D(r0,alpha,beta,gamma,x_B,y_B,z_B);
[vo_x,vo_y,vo_z]=transform_3D([0,0,0],alpha,beta,gamma,v_x2,v_y2,v_z2);

end


%{
+[M函数](,抛物型柱面镜反射)
%}