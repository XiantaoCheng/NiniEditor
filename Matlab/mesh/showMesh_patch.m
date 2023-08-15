%% 20230423
%% from 文档/数学问题/有限元分析.ftxt
%{
地址::Matlab/mesh/showMesh_patch.m
+[保存M函数](,showMesh_patch)
测试:...
%}

function showMesh_patch(pts_x,pts_y,lines_1,lines_2,faces)

hold on
plot(pts_x,pts_y,'o')
for i=1:length(pts_x)
    text(pts_x(i),pts_y(i),num2str(i));
end

for i=1:length(lines_1)
    is_draw=[lines_1(i),lines_2(i)];
    plot(pts_x(is_draw),pts_y(is_draw),'b-')
end

for i=1:size(faces,2)
    face=faces(:,i)';
    ns=[lines_1(face),lines_2(face)];
    xs=pts_x(ns);
    ys=pts_y(ns);
    zs=zeros(size(xs))-i;
    patch(xs,ys,zs,[0.8,0.8,0.8])
end

axis equal

end

%{
+[保存M函数](,showMesh_patch)
%}

