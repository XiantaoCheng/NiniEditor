%% 20230729
%% from 文档\S应用\三维建模.ftxt
%{
+[保存M函数](,draw_sphere_fill)
地址::Matlab/draw/draw_sphere_fill.m
%}

function draw_sphere_fill(pt,R)
[X,Y,Z]=sphere();

X=X'*R+pt(1);
Y=Y'*R+pt(2);
Z=Z'*R+pt(3);

N=size(X,2);
for i=1:N-1
    fill_3D(X(:,i),Y(:,i),Z(:,i),X(:,i+1),Y(:,i+1),Z(:,i+1),[0.5,0.5,0.5]);
end

patch(X(:,1),Y(:,1),Z(:,1),[0.95,0.95,0.95],'FaceAlpha',0.5,'EdgeALpha',0);
patch(X(:,end),Y(:,end),Z(:,end),[0.95,0.95,0.95],'FaceAlpha',0.5,'EdgeALpha',0);

end



