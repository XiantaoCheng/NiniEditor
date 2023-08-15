%{
地址::Matlab\spectrometer\AutoCalibrationIP.m
+[保存文本](,AutoCalibrationIP)

测试函数(M函数):...
%}



function [cellx,dy,sx,xo]=AutoCalibrationIP(shadow,Cell,dy2,IP,Fx,Fy,show_mode,dy,n)
% shadow=[1855,1899,2016,2022,2133];
% Cell=[0.225 0];
% dy2=-0.000632;
% show_mode=1;
% dy=[0 0];
% if LWFA==7
%     IP=-2.48;
%     Fiducial2=-1.545;
%     Fiducial1=-1.037;
% else
%     IP=-2.476;
%     Fiducial2=IP+0.93345;
%     Fiducial1=IP+1.44145;
% end

% IP=-2.48;
% Fiducial2=-1.545;
% Fiducial1=-1.037;



if n==0
    cellx=Cell(2);
    return;
end

if n==1
    [xo,Fn]=XrayAutoMatch(shadow,Cell,dy,IP,Fx,Fy,show_mode);
else
    [xo,Fn]=XrayAutoMatch(shadow,Cell,dy,IP,Fx,Fy,0);
end


xo1=xo(Fn(:,2)==1);
xo2=xo(Fn(:,2)==2);
zs=IP;
zf1=Fx(1,1);
zf2=Fx(2,1);
zo=Cell(1);

dxo=mean(xo1)-mean(xo2);
Cf2=(zo-zs)/(zf2-zs);
Cs1=(zf1-zo)/(zf1-zs);
Cs2=(zf2-zo)/(zf2-zs);

dy1=(-dxo+Cf2*dy2)/(Cs1-Cs2)/3;
dy=dy+[dy1 dy2];

if n<=1
    cellx=mean(xo);
    sx=std(xo);
else
    Cell(2)=mean(xo);
    [cellx,dy,sx,xo]=AutoCalibrationIP(shadow,Cell,0,IP,Fx,Fy,show_mode,dy,n-1);
end
end