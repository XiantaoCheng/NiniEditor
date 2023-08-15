%% 20221104
%% from 文档\实验室问题\LWFA数据分析.ftxt
%{
地址::Matlab\spectrometer\scan_spectrometer_10808.m
+[保存M函数](,扫描代码)
%}


function [a,Fn,e,theta,energy,E_p] = scan_spectrometer_10808(dr_e,dr_m,dr_f1,dr_f2,dr_p,pt0,Dtheta)
addpath('Matlab\spectrometer');
physics_constant;
e_charge=e;

%pt0=[0,0];
%Dtheta=10;

shadow0=[403.0, 658.0, 851.0, 1045.0, 1166.0, 1331.0, 1421.0, 1549.0, 1623.0, 1723.0, 1791.0, 1542.0, 1440.0, 1344.0, 1220.0, 1878.0];
Cell0=[-26.4,0,0];
IP=[247.6,0,0];
size_m=[5,5];
pos_m=[2.5,0,-3];
B0=1.4820;
pos_f1=[103.45499999999998, 0.0, 0.0];
pos_f2=[154.255, 0.0, 0.0];
f1=[-6.588760000000001, -4.754880000000002, -3.444240000000002, -2.4384, -1.6014700000000013, -0.8432800000000019, 0.0, 0.7848599999999981];
f2=[-8.361680000000002, -5.971540000000001, -4.2291, -2.89433, -1.772920000000001, -0.7620000000000018, 0.0, 0.767079999999999];

% shadow=4001-shadow0/2;
shadow=shadow0;
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
% size(Fx);

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


% E=-B0*e*c*diff(Ma)*(z_i-mean(Ma))./(x_i-x_o-t_0*(z_i-z_o));
% shY=(shadow-2000)*1e-4+IPy;
E_p=@(pixel)-B0*e_charge*c*diff(Ma)*(IPx-mean(Ma))./((pixel-2000)*1e-4+IPy-Cell(2)-mean(a)*(IPx-Cell(1)));

end



%{
+[保存M函数](,扫描代码)
%}

