%% 20230423
%% from 文档/数学问题/有限元分析.ftxt
%{
地址::Matlab/mesh/showMesh_2D.m
+[保存M函数](,showMesh_2D)
测试:...
%}

function showMesh_2D(pts_x,pts_y,lines_1,lines_2)

hold on
plot(pts_x,pts_y,'o')
for i=1:length(pts_x)
    text(pts_x(i),pts_y(i),num2str(i));
end

for i=1:length(lines_1)
    is_draw=[lines_1(i),lines_2(i)];
    plot(pts_x(is_draw),pts_y(is_draw),'b-')
end
axis equal

end

%{
+[保存M函数](,showMesh_2D)
%}

