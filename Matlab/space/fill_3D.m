%% 20230725
%% from 文档\S应用\三维建模.ftxt
%{
+[M函数](,fill_3D)
地址::Matlab/space/fill_3D.m

+[保存M函数](,fill_3D)
%}
function fill_3D(x1,y1,z1,x2,y2,z2,color)

if length(color)>3
    alpha=color(4);
    color=color(1:3);
else
    alpha=0.5;
end

for i=1:length(x1)-1
    patch([x1(i),x1(i+1),x2(i+1),x2(i)],[y1(i),y1(i+1),y2(i+1),y2(i)],...
    [z1(i),z1(i+1),z2(i+1),z2(i)],color,'EdgeAlpha',0,'FaceAlpha',0.5)
end

end

