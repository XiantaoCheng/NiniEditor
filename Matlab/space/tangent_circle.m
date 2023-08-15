%% 20230515
%% from 文档\数学问题\平面几何.ftxt
%{
地址::Matlab/space/tangent_circle.m
+[保存M函数](,tangent_circle)
测试:...
+[新建阅读窗口](,测试)
%}

function [angle_1,angle_2,pt_1,pt_2]=tangent_circle(x_0,y_0,R,x_1,y_1)

% x_1=0.1;
% y_1=3;
% x_0=0.2;
% y_0=0.5;
% R=1.2;

a=((y_1-y_0).^(2)-R.^(2));
b_1=(-(x_1-x_0).*(y_1-y_0)+R.*sqrt((x_1-x_0).^(2)+(y_1-y_0).^(2)-R.^(2)));
b_2=(-(x_1-x_0).*(y_1-y_0)-R.*sqrt((x_1-x_0).^(2)+(y_1-y_0).^(2)-R.^(2)));

ry=-a/sqrt(a^2+b_1^2);
rx1=b_1/sqrt(a^2+b_1^2);
rx2=b_2/sqrt(a^2+b_2^2);

angle_1=sign_1(ry)*acosd(rx1);
angle_2=sign_1(ry)*acosd(rx2);

x_t=(a*R.^(2))./(a.*(x_1-x_0)+b_1.*(y_1-y_0))+x_0;
y_t=(b_1*R.^(2))./(a.*(x_1-x_0)+b_1*(y_1-y_0))+y_0;
pt_1=[x_t,y_t];

x_t=(a*R.^(2))./(a.*(x_1-x_0)+b_2.*(y_1-y_0))+x_0;
y_t=(b_2*R.^(2))./(a.*(x_1-x_0)+b_2*(y_1-y_0))+y_0;
pt_2=[x_t,y_t];


end


%{
+[保存M函数](,tangent_circle)
%}

