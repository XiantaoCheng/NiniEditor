%% 20220513
%% from 文档\实验室问题\能谱仪校正.ftxt
%{
地址::Matlab\spectrometer\match_pts.m
+[保存M函数](,match_pts)

测试(M函数):...
测试2(M函数):...
+[M函数](,测试2)
%}

function [i,I,J]=match_pts(xo,yo,xf,yf,xs,ys)

[Xs,Xf]=meshgrid(xs,xf);
[Ys,Yf]=meshgrid(ys,yf);

dY_s=zeros(size(xo));
for i=1:length(xo)
    Yo=Yf+(Yf-Ys)./(Xf-Xs).*(xo(i)-Xf);
    dY=abs(Yo-yo(i));
    I=find(dY==min(dY));
    dY_s(i)=std(dY(I));
end

i=find(dY_s==min(dY_s));

Yo=Yf+(Yf-Ys)./(Xf-Xs).*(xo(i(1))-Xf);
dY=abs(Yo-yo(i(1)));
[I,J]=find(dY==min(dY));

end

%{
+[保存M函数](,match_pts)
%}

