%{
+[M函数](,计算发射角)

地址::Matlab\spectrometer\X_match_13975.m
+[保存文本](,X_match_13975)

Nini, 打开能谱仪校正的match_pts(节点)
%}


function [i,I,J]=X_match_13975(dr_e,dr_m,dr_f1,dr_f2,dr_p,pt0,Dtheta)
addpath('Matlab\spectrometer');

%pt0=[0,0];
%Dtheta=10;

shadow0=[3584.35786700656, 3746.13394316645, 3905.56543851243, 3974.73057252281, 4202.15482926327, 4246.70186472759, 4503.43346385089, 4557.35882257085];
Cell0=[-18.32 -0.645 0];
IP=[265.1 0.19105 0];
size_m=[6.7 5];
pos_m=[-5.1 0 -3];
B0=1.1;
pos_f1=[120.9 0 0];
%pos_f2=[171.7 0.016 0];
pos_f2=[171.7 0 0];
f1=[-6.58876 -4.75488 -3.44424 -2.4384 -1.60147 -0.843280000000002 0 0.784859999999998];
f2=[-8.36168 -5.97154 -4.2291 -2.89433 -1.77292 -0.762000000000002 0 0.767079999999999];



shadow=4001-shadow0/2;
Cell=Cell0(1:2)*1e-2;
Ma=[0,size_m(1)]+pos_m(1);
Ma=Ma*1e-2;
Fx1=pos_f1(1)*1e-2;
Fx2=pos_f2(1)*1e-2;
Fy1=pos_f1(2)*1e-2;
Fy2=pos_f2(2)*1e-2;
IPx=IP(1)*1e-2;
IPy=IP(2)*1e-2;

Cell=Cell+dr_e;
Ma=Ma+dr_m(1);
Fx1=Fx1+dr_f1(1);
Fx2=Fx2+dr_f2(1);
Fy1=Fy1+dr_f1(2);
Fy2=Fy2+dr_f2(2);
IPx=IPx+dr_p(1);
IPy=IPy+dr_p(2);

shX=IPx*ones(size(shadow));
shY=(shadow-2000)*1e-4+IPy;

Fy=[f1*1e-2+Fy1;f2*1e-2+Fy2];
Fx=[Fx1*ones(size(f1));Fx2*ones(size(f2))];


% rotation
Fx=Fx-pt0(1);
Fy=Fy-pt0(2);
Fx=Fx*cosd(Dtheta)-Fy*sind(Dtheta);
Fy=Fy*cosd(Dtheta)+Fx*sind(Dtheta);
Fx=Fx+pt0(1);
Fy=Fy+pt0(2);

shX=shX-pt0(1);
shY=shY-pt0(2);
shX=shX*cosd(Dtheta)-shY*sind(Dtheta);
shY=shY*cosd(Dtheta)+shX*sind(Dtheta);
shX=shX+pt0(1);
shY=shY+pt0(2);



xo=Cell(1);
yo=Cell(2);
xf=reshape(Fx,1,numel(Fx));
yf=reshape(Fy,1,numel(Fy));
xs=shX;
ys=shY;

[i,I,J]=match_pts(xo,yo,Fx,Fy,shX,shY);
f1=find(mod(I,2)==0);
f2=find(mod(I,2)==1);

% yfo=ys(J)+(xo-xs(J)).*(yf(I)-ys(J))./(xf(I)-xs(J));

x=xo-5e-3*ones(1,length(I));
y=ys(J)+(x-xs(J)).*(yf(I)-ys(J))./(xf(I)-xs(J));


plot(xo,yo,'o',xf,yf,'o',xs,ys,'o'...
    ,[xs(J(f1));x(f1)],[ys(J(f1));y(f1)],'r'...
    ,[xs(J(f2));x(f2)],[ys(J(f2));y(f2)],'b')

axis([xo-0.1,xo+0.1,yo-2e-3,yo+2e-3]);

end


%{
+[保存文本](,X_match_13975)
%}