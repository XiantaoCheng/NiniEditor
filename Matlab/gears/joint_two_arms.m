%% 20220724
%% from 文档\S应用\齿轮模拟.ftxt
%{
地址::Matlab\gears\joint_two_arms.m
+[保存M函数](,joint_two_arms)
%}

function [pt1,pt2]=joint_two_arms(pt_1,pt_2,L_1,L_2)
% L_1=4;
% L_2=4;
x_1=pt_1(1);
y_1=pt_1(2);
x_2=pt_2(1);
y_2=pt_2(2);

DX_1=x_1-x_2;
DY_1=y_1-y_2;

D=L_1.^(2)-(y_1-y_2).^(2)-(x_1-x_2).^(2)-L_2.^(2);
DX1=(-D.*DX_1-sqrt(4.*L_2.^(2).*DY_1.^(2).*(DX_1.^(2)+DY_1.^(2))-(D.*DY_1).^(2)))./(2.*(DX_1.^(2)+DY_1.^(2)));
DX2=(-D.*DX_1+sqrt(4.*L_2.^(2).*DY_1.^(2).*(DX_1.^(2)+DY_1.^(2))-(D.*DY_1).^(2)))./(2.*(DX_1.^(2)+DY_1.^(2)));

x1=DX1+x_2;
x2=DX2+x_2;


DY1=sqrt(L_2.^(2)-DX1.^(2));
DY2=-sqrt(L_2.^(2)-DX2.^(2));

y1=DY1+y_2;
y2=DY2+y_2;

if abs(sqrt((x1-x_1)^2+(y1-y_1)^2)-L_1)>1e-6
    y1=-DY1+y_2;
end
if abs(sqrt((x2-x_1)^2+(y2-y_1)^2)-L_1)>1e-6
    y2=-DY2+y_2;
end

test=cross([x1-x_1,y1-y_1,0],[x1-x_2,y1-y_2,0]);
test=test(3);
if test<0
    pt2=[x1,y1];
    pt1=[x2,y2];
else
    pt1=[x1,y1];
    pt2=[x2,y2];
end



end


%{
+[保存M函数](,joint_two_arms)
%}

