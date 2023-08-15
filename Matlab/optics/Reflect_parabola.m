%{
+[M函数](,Reflect_parabola)
地址::Matlab\optics\Reflect_parabola.m

+[保存文本](,Reflect_parabola)
%}

function [x_B,y_B,theta3,theta2]=Reflect_parabola(x_A,y_A,theta1,a,b,c)
%a=1;
%b=1;
%c=1;

%theta1=-90;
%x_A=pt_A[1];
%y_A=pt_A[2];

v1=cosd(theta1);
u1=sind(theta1);

x_B=(-(b*v1-u1)+sqrt((2*a*v1.*x_A+b*v1-u1).^2-4*a*v1.^2.*(a*x_A.^2+b*x_A-y_A+c)))/2/a./v1;
x_B(v1==0)=x_A(v1==0);
y_B=a*x_B.^2+b*x_B+c;

tan2=2*a*x_B+b;
theta2=atand(tan2);
theta3=2*theta2-theta1;

end

%{
+[M函数](,验证算法)
%}