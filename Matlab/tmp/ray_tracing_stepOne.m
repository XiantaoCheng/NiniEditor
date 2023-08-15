%% 20230731
%% from 文档/计算机问题/光线追踪.ftxt
%{
地址::Matlab/tmp/ray_tracing_stepOne.m
+[保存M函数](,ray_tracing_stepOne)

ray_tracing_diffusion:...
+[新建阅读窗口](,ray_tracing_diffusion)
测试:...
%}

function pic_color=ray_tracing_stepOne(x_1,y_1,z_1,v_x,v_y,v_z,xs,ys,zs,Rs,n_2,r_ratio,emission,xb,yb,zb,faces,n)

addpath('Matlab/optics');

i_min=zeros(size(x_1));
t_min=inf*ones(size(x_1));

for i=1:length(xs)
    [t_2,t_3]=intersection_sphere_3D(x_1,y_1,z_1,v_x,v_y,v_z,xs(i),ys(i),zs(i),Rs(i));
    t_0=min([t_2;t_3]);
    it=imag(t_2)==0 & t_min>t_0 & t_0>1e-8;
    t_min(it)=t_0(it);
    i_min(it)=i;
end

j_min=zeros(size(x_1));
for i=1:size(faces,1)
    fs=faces(i,:);

    t_0=intersection_plane_3D(x_1,y_1,z_1,v_x,v_y,v_z,xb(fs),yb(fs),zb(fs));
    it=t_min>t_0 & t_0>1e-8;
    t_min(it)=t_0(it);
    j_min(it)=i;
end

% si=i_min~=0;
% sj=i_min==0;
si=j_min==0;
sj=j_min~=0;
[x_2,y_2,z_2,v_1_x,v_1_y,v_1_z,v_2_x,v_2_y,v_2_z]=reflect_refract_sphere_3D(x_1(si),y_1(si),z_1(si),v_x(si),v_y(si),v_z(si),t_min(si),xs(i_min(si)),ys(i_min(si)),zs(i_min(si)),Rs(i_min(si)),1,n_2);

x_1(si)=x_2;
y_1(si)=y_2;
z_1(si)=z_2;
v_x(si)=v_1_x;
v_y(si)=v_1_y;
v_z(si)=v_1_z;

Dx1=xb(faces(j_min(sj),1))-xb(faces(j_min(sj),2));
Dx2=xb(faces(j_min(sj),2))-xb(faces(j_min(sj),3));
Dy1=yb(faces(j_min(sj),1))-yb(faces(j_min(sj),2));
Dy2=yb(faces(j_min(sj),2))-yb(faces(j_min(sj),3));
Dz1=zb(faces(j_min(sj),1))-zb(faces(j_min(sj),2));
Dz2=zb(faces(j_min(sj),2))-zb(faces(j_min(sj),3));

y_x=Dy1.*Dz2-Dy2.*Dz1;
y_y=Dz1.*Dx2-Dz2.*Dx1;
y_z=Dx1.*Dy2-Dx2.*Dy1;
% y_x,y_y,y_z

% [x_2,y_2,z_2,v_1_x,v_1_y,v_1_z,v_2_x,v_2_y,v_2_z]=reflect_refract_plane_3D(x_1(sj),y_1(sj),z_1(sj),v_x(sj),v_y(sj),v_z(sj),t_min(sj),y_x,y_y,y_z,1,n_2);
[x_2,y_2,z_2,v_1_x,v_1_y,v_1_z]=ray_tracing_diffusion(x_1(sj),y_1(sj),z_1(sj),v_x(sj),v_y(sj),v_z(sj),t_min(sj),y_x,y_y,y_z);



x_1(sj)=x_2;
y_1(sj)=y_2;
z_1(sj)=z_2;
v_x(sj)=v_1_x;
v_y(sj)=v_1_y;
v_z(sj)=v_1_z;

if n>0
    pic_color=ray_tracing_stepOne(x_1,y_1,z_1,v_x,v_y,v_z,xs,ys,zs,Rs,n_2,r_ratio,emission,xb,yb,zb,faces,n-1);
else
    pic_color=zeros(size(x_1));
end

% pic_color(sj)=pic_color(sj)+emission;
% pic_color(si)=pic_color(si)*r_ratio;

pic_color(si)=pic_color(si).*r_ratio(i_min(si));
pic_color(si)=pic_color(si)+emission(i_min(si));
pic_color(sj)=pic_color(sj)*0.9;
% pic_color(sj)=pic_color(sj)+0.3;


end


%{
1
+[保存M函数](,ray_tracing_stepOne)
%}

