%{
+[返回目录]

地址::Matlab\MidIR\toCodeV.m
+[保存文本](,地址)

转换公式:...

含义:...
%}

function [pt2,drc2]=toCodeV(pt0,drc0,pt1,drc1)
%drc0=[45,90,0];
%drc1=[10,10,0];
%pt0=[0,0,0];
%pt1=[1,1,1];

x=[1,0,0];
y=[0,1,0];
z=[0,0,1];

xx=[0,-1,0];
yy=[0,0,-1];
zz=[1,0,0];

[x0,y0,z0]=rotate3D(drc0(1),drc0(2),drc0(3),xx,yy,zz);
[x1,y1,z1]=rotate3D(drc1(1),drc1(2),drc1(3),x,y,z);

set0=[x0;y0;z0];
set1=[x1;y1;z1];

pt2=zeros(size(pt1));
pt2(:,1)=x0(1)*(pt1(:,1)-pt0(1))+y0(1)*(pt1(:,2)-pt0(2))+z0(1)*(pt1(:,3)-pt0(3));
pt2(:,2)=x0(2)*(pt1(:,1)-pt0(1))+y0(2)*(pt1(:,2)-pt0(2))+z0(2)*(pt1(:,3)-pt0(3));
pt2(:,3)=x0(3)*(pt1(:,1)-pt0(1))+y0(3)*(pt1(:,2)-pt0(2))+z0(3)*(pt1(:,3)-pt0(3));


z10x=x1(3)*x0(1)+y1(3)*y0(1)+z1(3)*z0(1);
z10y=x1(3)*x0(2)+y1(3)*y0(2)+z1(3)*z0(2);
z10z=x1(3)*x0(3)+y1(3)*y0(3)+z1(3)*z0(3);
z10=[z10x,z10y,z10z];

alpha=asind(z10(1));
if z10(3)==0 && z10(2)==0
    beta=0;
elseif z10(2)<0 && z10(3)>0
    beta=atand(z10(3)/z10(2))+180;
elseif z10(2)<0 && z10(3)<0
    beta=atand(z10(3)/z10(2))-180;
elseif z10(2)<0 && z10(3)==0
    beta=180;
else
    beta=atand(z10(3)/z10(2));
end
drc2=[alpha,beta,0];
end