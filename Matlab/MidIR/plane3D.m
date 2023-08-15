%{
+[返回目录]
地址::Matlab\MidIR\plane3D.m
+[保存文本](,三维镜面)
%}


function plane3D(pt,shape,drc)
x=[-shape(1)/2,+shape(1)/2,+shape(1)/2,-shape(1)/2];
y=[-shape(2)/2,-shape(2)/2,+shape(2)/2,+shape(2)/2];
z=[0,0,0,0];

[x,y,z]=rotate3D(drc(1),drc(2),drc(3),x,y,z);
x=x+pt(1);
y=y+pt(2);
z=z+pt(3);

patch(x,y,z,[0.8,0.8,1],'FaceAlpha',0.7);

end