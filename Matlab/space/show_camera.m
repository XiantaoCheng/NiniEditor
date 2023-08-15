%{
+[返回目录](,show_camera)
地址::Matlab\space\show_camera.m
+[保存文本](,show_camera)

%}

function show_camera(r0,Eulers,D)
%r0=[10,10,10];
%Eulers=[30,30,30];
%D=1;

addpath('Matlab\space');

orig_x0=zeros(1,4);
orig_y0=zeros(1,4);
orig_z0=zeros(1,4);
photo_x0=[1,1,-1,-1]/2;
photo_y0=[-1,1,1,-1]/2;
photo_z0=D*ones(1,4);
po_x0=[0,0];
po_y0=[0,0];
po_z0=[D,D];
axis_x0=[1,0];
axis_y0=[0,1];
axis_z0=[0,0];

[orig_x,orig_y,orig_z]=transform_3D(r0,Eulers(1),Eulers(2),Eulers(3),...
orig_x0,orig_y0,orig_z0);
[photo_x,photo_y,photo_z]=transform_3D(r0,Eulers(1),Eulers(2),Eulers(3),...
photo_x0,photo_y0,photo_z0);
[po_x,po_y,po_z]=transform_3D(r0,Eulers(1),Eulers(2),Eulers(3),...
po_x0,po_y0,po_z0);
[axis_x,axis_y,axis_z]=transform_3D([0,0,0],Eulers(1),Eulers(2),Eulers(3),...
axis_x0,axis_y0,axis_z0);

plot3([orig_x;photo_x],[orig_y;photo_y],[orig_z;photo_z],'k')
hold on
quiver3(po_x,po_y,po_z,axis_x,axis_y,axis_z)
patch(photo_x,photo_y,photo_z,[1,1,1]);
text(po_x+axis_x,po_y+axis_y,po_z+axis_z,{'x','y'})
hold off


end

%{
+[M函数](,show_camera)
%}