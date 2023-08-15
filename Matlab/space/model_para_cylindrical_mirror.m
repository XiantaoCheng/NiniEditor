%{
+[M函数](,model_para_cylindrical_mirror)
地址::Matlab\space\model_para_cylindrical_mirror.m

+[保存文本](,model_para_cylindrical_mirror)
%}

function model_para_cylindrical_mirror(a,W,D,H,Eulers,orig_0)

% mirror
%a=0.01;
%W=20;
%H=5;
%D=1;

x=linspace(-W/2,W/2,10);

x10=x;
y10=zeros(size(x10))+H/2;
z10=a*x10.^2;

x20=x;
y20=zeros(size(x20))-H/2;
z20=a*x20.^2;

x30=x;
y30=zeros(size(x10))-H/2;
z30=zeros(size(x10))-D;

x40=x;
y40=zeros(size(x10))+H/2;
z40=zeros(size(x10))-D;


alpha=Eulers(1);
beta=Eulers(2);
gamma=Eulers(3);

[x1,y1,z1]=transform_3D(orig_0,alpha,beta,gamma,x10,y10,z10);
[x2,y2,z2]=transform_3D(orig_0,alpha,beta,gamma,x20,y20,z20);
[x3,y3,z3]=transform_3D(orig_0,alpha,beta,gamma,x30,y30,z30);
[x4,y4,z4]=transform_3D(orig_0,alpha,beta,gamma,x40,y40,z40);



end1_x=[x1(1),x2(1);x4(1),x3(1)];
end1_y=[y1(1),y2(1);y4(1),y3(1)];
end1_z=[z1(1),z2(1);z4(1),z3(1)];

end2_x=[x1(end),x2(end);x4(end),x3(end)];
end2_y=[y1(end),y2(end);y4(end),y3(end)];
end2_z=[z1(end),z2(end);z4(end),z3(end)];


plot3([x1;x2;x3;x4]',[y1;y2;y3;y4]',[z1;z2;z3;z4]','k-',...
end1_x,end1_y,end1_z,'k',end1_x',end1_y',end1_z','k',...
end2_x,end2_y,end2_z,'k',end2_x',end2_y',end2_z','k'...
)

fill_3D(x1,y1,z1,x2,y2,z2,[0.9,0.9,1]);
fill_3D(x2,y2,z2,x3,y3,z3,[0.9,0.9,1]);
fill_3D(x3,y3,z3,x4,y4,z4,[0.9,0.9,1]);
fill_3D(x4,y4,z4,x1,y1,z1,[0.9,0.9,1]);
fill_3D(end1_x(1:2),end1_y(1:2),end1_z(1:2),...
    end1_x(3:4),end1_y(3:4),end1_z(3:4),[0.9,0.9,1]);
fill_3D(end2_x(1:2),end2_y(1:2),end2_z(1:2),...
    end2_x(3:4),end2_y(3:4),end2_z(3:4),[0.9,0.9,1]);

end

%{
+[M函数](,patch测试)
%}