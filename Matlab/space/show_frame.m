%{
+[返回目录](,局域坐标系)
地址::Matlab\space\show_frame.m
+[保存文本](,局域坐标系)

+[M函数](,局域坐标系)
%}

function show_frame(orig,alpha,beta,gamma,D)
% orig=[0,0,10];
% alpha=30;
% beta=30;
% gamma=30; 
% D=1;

addpath('Matlab\space');

plane_X0=[D/2,D/2,-D/2,-D/2];
plane_Y0=[-D/2,D/2,D/2,-D/2];
plane_Z0=zeros(1,4);
[plane_X,plane_Y,plane_Z]=transform_3D(orig,alpha,beta,gamma,...
    plane_X0,plane_Y0,plane_Z0);

r_x0=[1,0,0];
r_y0=[0,1,0];
r_z0=[0,0,1];
[r_x,r_y,r_z]=transform_3D([0,0,0],alpha,beta,gamma,...
    r_x0,r_y0,r_z0);


quiver3(orig(1)*ones(1,3),orig(2)*ones(1,3),orig(3)*ones(1,3),r_x,r_y,r_z);
patch(plane_X,plane_Y,plane_Z,[1,1,1])
text(orig(1)+r_x,orig(2)+r_y,orig(3)+r_z,{'x','y','z'})

end


%{
+[M函数](,局域坐标系)
%}