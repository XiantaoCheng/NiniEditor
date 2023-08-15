%% 20220416
%% from 文档\实验室问题\能谱仪校正.ftxt
%{
地址::Matlab\spectrometer\scan_spectrometer_13975.m
+[保存M函数](,scan_spectrometer_13975)

Nini, 打开能谱仪原理(文件)
Nini, 打开能谱仪原理的LaunchAngles(节点)
Nini, 打开能谱仪原理的trajectory_fs(节点)

DesignTool1(M函数):...
DesignTool2(M函数):...
记住DesignTool1(节点)
保存:...
shX
%}


function [a,Fn,e,theta,energy]=scan_spectrometer_13975(dr_e,dr_m,dr_f1,dr_f2,dr_p,pt0,Dtheta)
addpath('Matlab\spectrometer');

%pt0=[0,0];
%Dtheta=10;

shadow0=[4207 4264 4516 4597 4862.15428101106 4961.79896560229 5272.45584655822 5400.23550091639 5808.19261938067 5967.62411472665 6540.87398391396 6764.7814516425];
Cell0=[-18.32 -0.645 0];
IP=[265.1 0.19105 0];
size_m=[6.7 5];
pos_m=[-5.1 0 -3];
B0=1.1;
pos_f1=[120.9 0 0];
pos_f2=[171.7 0 0];
f1=[-6.58876 -4.75488 -3.44424 -2.4384 -1.60147 -0.843280000000002 0 0.784859999999998];
f2=[-8.36168 -5.97154 -4.2291 -2.89433 -1.77292 -0.762000000000002 0 0.767079999999999];



shadow=4001-shadow0/2;
Cell=Cell0(1:2)*1e-2;
Ma=[-1/2,1/2]*size_m(1)+pos_m(1);
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



% [a,Fn,e,theta,energy]=LaunchAngles(shadow,Cell,dy,Ma,B0,Fx,Fy,IPx);
% [a,Fn,e,theta,energy]=DesignTool1(Cell,Ma,B0,Fx,Fy,shX,shY);
[a,Fn,e,theta,energy]=DesignTool2(Cell,Ma,B0,Fx,Fy,shX,shY);

end



%{
+[保存M函数](,scan_spectrometer_13975)
%}

