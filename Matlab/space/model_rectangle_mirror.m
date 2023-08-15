%{
+[M函数](,model_rectangle_mirror)
地址::Matlab\space\model_rectangle_mirror.m

+[保存文本](,model_rectangle_mirror)
代码测试(M函数):...
%}

function model_rectangle_mirror(W,H,D,Eulers,orig_0)

% mirror
%W=1;
%H=1;
%D=1;
%Eulers=[0,0,0];
%orig_0=[0,0,0];

x10=[W/2,W/2,-W/2,-W/2,W/2];
y10=[-H/2,H/2,H/2,-H/2,-H/2];
z10=0*ones(size(x10));

x20=x10;
y20=y10;
z20=-D*ones(size(x20));

alpha=Eulers(1);
beta=Eulers(2);
gamma=Eulers(3);

[x1,y1,z1]=transform_3D(orig_0,alpha,beta,gamma,x10,y10,z10);
[x2,y2,z2]=transform_3D(orig_0,alpha,beta,gamma,x20,y20,z20);

plot3([x1;x2]',[y1;y2]',[z1;z2]','k-')

patch(x1,y1,z1,[0.9,0.9,1]);
patch(x2,y2,z2,[0.9,0.9,1]);
fill_3D(x1,y1,z1,x2,y2,z2,[0.9,0.9,1]);

end

%{
+[M函数](,patch测试)
%}