%% 20221103
%% from 文档\S应用\人体模型.ftxt
%{
地址::Matlab\space\Local_coordinates_pts_Eulers.m
+[保存M函数](,Local_coordinates_pts_Eulers)
测试:...
%}

function [xo,yo,zo,v_x,v_y,v_z,pt]=Local_coordinates_pts_Eulers(x,y,z,pt_1,pt_3,Eulers)

% x=0;
% y=0;
% z=0;
% pt_1=[1,0,0];
% pt_2=[2,2,2];
% pt_3=[1,2,3];

[~,~,Z]=Euler_frame(Eulers(1),Eulers(2),Eulers(3));

x1=reshape(x,1,numel(x));
y1=reshape(y,1,numel(y));
z1=reshape(z,1,numel(z));

v_13=pt_3-pt_1;

v_x=Z;
v_z=cross(v_x,v_13);
v_z=v_z/norm(v_z);
v_y=cross(v_z,v_x);
pt=pt_1;

x2=(x1-pt(1))*v_x(1)+(y1-pt(2))*v_x(2)+(z1-pt(3))*v_x(3);
y2=(x1-pt(1))*v_y(1)+(y1-pt(2))*v_y(2)+(z1-pt(3))*v_y(3);
z2=(x1-pt(1))*v_z(1)+(y1-pt(2))*v_z(2)+(z1-pt(3))*v_z(3);


xo=reshape(x2,size(x));
yo=reshape(y2,size(y));
zo=reshape(z2,size(z));

end


%{
+[M函数](,Local_coordinates_3_pts)
%}

