%{
+[M函数](,model_round_mirror)
地址::Matlab\space\model_round_mirror.m

+[保存文本](,model_round_mirror)
代码测试(M函数):...
%}

function model_round_mirror(R,D,Eulers,orig_0)

% mirror
%R=10;
%D=1;
%Eulers=[0,0,0];
%orig_0=[0,75,0];


t=linspace(0,360,100);

x10=R*cosd(t);
y10=R*sind(t);
z10=0*ones(size(t));

x20=x10;
y20=y10;
z20=-D*ones(size(t));

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