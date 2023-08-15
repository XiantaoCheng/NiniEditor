%{
+[返回目录]
地址::Matlab\MidIR\circle3D.m
+[保存文本](,三维圆面)
%}


function circle3D(pt,R,drc)
theta=linspace(0,360,100);
x=R*cosd(theta);
y=R*sind(theta);
z=zeros(size(x));

[x,y,z]=rotate3D(drc(1),drc(2),drc(3),x,y,z);
x=x+pt(1);
y=y+pt(2);
z=z+pt(3);

patch(x,y,z,[0.8,0.8,1],'FaceAlpha',0.7);

end