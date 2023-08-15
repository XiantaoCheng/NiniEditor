%% 20220607
%% from 文档\实验室问题\能谱仪校正.ftxt
%{
地址::Matlab\spectrometer\calibrationIP.m
+[保存M函数](,calibrationIP)

保存:...
测试(M函数):...
测试_电子影子(M函数):...
figure
+[M函数](,测试)
hold on
+[M函数](,测试_电子影子)
f1
%}


function [xo,yo,ys,I,J,f1,f2,xf,yf]=calibrationIP(xo,yo,Dx,Dy,Fx,Fy,xs,ys,n)

N=100;

xf=reshape(Fx,1,numel(Fx));
yf=reshape(Fy,1,numel(Fy));

% shift x
xso=xo*ones(1,N);
yso=yo+linspace(-Dy/2,Dy/2,N);

[i,I,J]=match_pts(xso,yso,xf,yf,xs,ys);
f1=find(mod(I,2)==0);
f2=find(mod(I,2)==1);
xo2=xso(i(1));
yo2=yso(i(1));

% shift y
yso2=yo2*ones(1,N);
xso2=xo2+linspace(-Dx/2,Dx/2,N);

[i,I,J]=match_pts(xso2,yso2,xf,yf,xs,ys);
f1=find(mod(I,2)==0);
f2=find(mod(I,2)==1);
xo3=xso2(i(1));
yo3=yso2(i(1));

yfo=ys(J)+(xo-xs(J)).*(yf(I)-ys(J))./(xf(I)-xs(J));
dy=mean(yfo(f1))-mean(yfo(f2));

xo=xo3;
yo=yo3;
ys=ys+dy;

if n>0
    [xo,yo,ys,I,J,f1,f2]=calibrationIP(xo,yo,Dx,Dy*0.8,Fx,Fy,xs,ys,n-1);
end

end


%{
+[M函数](,calibrationIP)
执行calibrationIP(M函数)
%}

