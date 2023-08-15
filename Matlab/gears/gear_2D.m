%% 20220724
%% from 文档\S应用\齿轮模拟.ftxt
%{
地址::Matlab\gears\gear_2D.m
+[保存M函数](,gear_2D)
%}

function [x,y]=gear_2D(R1,R2,N)

%N=20;
%R1=1;
%R2=1.15;

DN=10;
A=0.2;
B=0.5;

angle=linspace(0,360,N*DN);
x=R1*cosd(angle);
y=R1*sind(angle);

for i=2:DN/2
I=(0:N-1)*DN+i;
x(I)=R2*cosd(angle(I));
y(I)=R2*sind(angle(I));
end

x0=A*R1*cosd(angle);
y0=A*R1*sind(angle);

x=[x,nan,x0,nan,x0,nan,x0+B*R1,nan,x0-B*R1,nan];
y=[y,nan,y0+B*R1,nan,y0-B*R1,nan,y0,nan,y0,nan];

end



