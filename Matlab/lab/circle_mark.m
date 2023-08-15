%{
+[M函数](,圆圈标记)
地址::Matlab\lab\circle_mark.m
+[保存文本](,圆圈标记)
%}

function circle_mark(r0,R0)

t=linspace(0,360,100);
% r0=[4.5,2.1];
% R0=1.7;
x0=R0*cosd(t)+r0(1);
y0=R0*sind(t)+r0(2);
z0=5*ones(size(t));

hold on
plot3(x0,y0,z0,'r--','LineWidth',2);
hold off
end