%% 20230515
%% from 文档\数学问题\平面几何.ftxt
%{
x_0
+[保存M函数](,tangent_two_circles)
地址::Matlab/space/tangent_two_circles.m
测试:...
%}

function [angle_1,angle_2,pt_1a,pt_1b,pt_2a,pt_2b]=tangent_two_circles(x_1,y_1,R_1,x_2,y_2,R_2)

x_3=(x_1.*R_2-x_2.*R_1)./(R_2-R_1);
y_3=(y_1.*R_2-y_2.*R_1)./(R_2-R_1);
pt_0=[x_3,y_3];

a=((y_3-y_1).^(2)-R_1.^(2));
b_1=(-(x_3-x_1).*(y_3-y_1)+R_1.*sqrt((x_3-x_1).^(2)+(y_3-y_1).^(2)-R_1.^(2)));
b_2=(-(x_3-x_1).*(y_3-y_1)-R_1.*sqrt((x_3-x_1).^(2)+(y_3-y_1).^(2)-R_1.^(2)));

ry=-a/sqrt(a^2+b_1^2);
rx1=b_1/sqrt(a^2+b_1^2);
rx2=b_2/sqrt(a^2+b_2^2);

angle_1=sign_1(ry)*acosd(rx1);
angle_2=sign_1(ry)*acosd(rx2);

x_t=(a*R_1.^(2))./(a.*(x_3-x_1)+b_1.*(y_3-y_1))+x_1;
y_t=(b_1*R_1.^(2))./(a.*(x_3-x_1)+b_1*(y_3-y_1))+y_1;
pt_1a=[x_t,y_t];
pt_2a=pt_0+(pt_1a-pt_0)/R_1*R_2;


x_t=(a*R_1.^(2))./(a.*(x_3-x_1)+b_2.*(y_3-y_1))+x_1;
y_t=(b_2*R_1.^(2))./(a.*(x_3-x_1)+b_2*(y_3-y_1))+y_1;
pt_1b=[x_t,y_t];
pt_2b=pt_0+(pt_1b-pt_0)/R_1*R_2;

end

%{
+[保存M函数](,tangent_two_circles)
%}

