%{
地址::Matlab\spectrometer\energy_ruler.m
+[保存文本](,energy_ruler)


E=200:100:2000;
B=1.48;
D=0.05;

x_s=0;
y_s=0;
x_m=15e-2;
theta=0;
x_i=200e-2;
%}

function y_i=energy_ruler(E,pos_s,theta,x_m,D,B,x_i)

physics_constant;
q=e;
m_0=me;

E=E*1e6*e;
x_s=pos_s(1);
y_s=pos_s(2);
x_m1=x_m-D/2;
x_m2=x_m+D/2;


y_m1=tan(theta).*(x_m1-x_s)+y_s;
R=(sqrt(E.^(2)./c.^(2)-m_0.^(2).*c.^(2)))./(q.*B);
beta=asin(sin(theta)-(D)./(R));
Delta=R.*(cos(beta)-cos(theta));
y_m2=y_m1+Delta;
y_i=tan(beta).*(x_i-x_m2)+y_m2;

% plot(y_i,E,'o')

end


