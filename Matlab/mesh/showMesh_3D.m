%% 20230424
%% from 文档/数学问题/有限元分析.ftxt
%{
地址::Matlab/mesh/showMesh_3D.m
+[保存M函数](,showMesh_3D)
测试:...
%}

function showMesh_3D(pts_x,pts_y,pts_z,lines_1,lines_2,faces)

hold on
plot3(pts_x,pts_y,pts_z,'o')
for i=1:length(pts_x)
    text(pts_x(i),pts_y(i),pts_z(i),num2str(i));
end

for i=1:length(lines_1)
    is_draw=[lines_1(i),lines_2(i)];
    plot3(pts_x(is_draw),pts_y(is_draw),pts_z(is_draw),'b-')
end

z_min=min(pts_z);
z_max=max(pts_z);
for i=1:size(faces,2)
    face=faces(:,i)';
    ns=[lines_1(face),lines_2(face)];
    xs=pts_x(ns);
    ys=pts_y(ns);
    zs=pts_z(ns);

%     c=(mean(zs)-z_min)/(z_max-z_min);
%     patch(xs,ys,zs,[1,1,1]*c)
    patch(xs,ys,zs,[0.8,0.8,0.8])

end

axis equal

end

%{
参考::https://www.mathworks.com/help/matlab/creating_plots/how-patch-data-relates-to-a-colormap.html
+[保存M函数](,showMesh_3D)
%}

